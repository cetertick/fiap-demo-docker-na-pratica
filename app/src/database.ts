import { Pool } from "pg";

const pool = new Pool({
  host: process.env.DATABASE_HOST || "localhost",
  port: Number(process.env.DATABASE_PORT || 5432),
  database: process.env.DATABASE_NAME || "appdb",
  user: process.env.DATABASE_USER || "app",
  password: process.env.DATABASE_PASSWORD || "devpassword"
});

export async function initDatabase(): Promise<void> {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS tasks (
      id SERIAL PRIMARY KEY,
      title TEXT NOT NULL,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now()
    )
  `);
}

export async function listTasks() {
  const result = await pool.query("SELECT id, title, created_at FROM tasks ORDER BY id");
  return result.rows;
}

export async function createTask(title: string) {
  const result = await pool.query(
    "INSERT INTO tasks(title) VALUES($1) RETURNING id, title, created_at",
    [title]
  );
  return result.rows[0];
}

export async function checkDatabase(): Promise<boolean> {
  try {
    await pool.query("SELECT 1");
    return true;
  } catch {
    return false;
  }
}
