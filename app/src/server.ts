import express from "express";
import os from "os";
import { checkDatabase, createTask, initDatabase, listTasks } from "./database";

const app = express();
const port = Number(process.env.PORT || 3000);

app.use(express.json());

app.get("/health", async (_req, res) => {
  const database = await checkDatabase();
  res.status(database ? 200 : 503).json({ status: database ? "ok" : "degraded", database });
});

app.get("/info", (_req, res) => {
  res.json({
    app: "docker-na-pratica-api",
    version: process.env.APP_VERSION || "1.0.0",
    environment: process.env.NODE_ENV || "development",
    hostname: os.hostname()
  });
});

app.get("/tasks", async (_req, res) => {
  res.json(await listTasks());
});

app.post("/tasks", async (req, res) => {
  const title = String(req.body?.title || "").trim();
  if (!title) {
    return res.status(400).json({ error: "title is required" });
  }
  res.status(201).json(await createTask(title));
});

initDatabase()
  .then(() => {
    app.listen(port, "0.0.0.0", () => {
      console.log(`API listening on port ${port}`);
    });
  })
  .catch((err) => {
    console.error("Database initialization failed", err);
    process.exit(1);
  });
