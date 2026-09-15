# Scripts - Docker na Prática

Este pacote contém os materiais operacionais para preparar a infraestrutura AWS do laboratório e uma aplicação de exemplo para a prática de Dockerfile multi-stage e Docker Compose.

## Uso previsto

- Execute a infraestrutura **antes da aula**, a partir do WSL Ubuntu 22.04.
- Use credenciais temporárias do AWS Academy Learner Lab via variáveis de ambiente.
- Não versione nem compartilhe credenciais.
- O laboratório oficial de Docker começa com a infraestrutura já provisionada.

## Pré-requisitos no WSL

```bash
aws --version
terraform version
terragrunt --version
jq --version
curl --version
ssh -V
```

## Credenciais AWS temporárias

Copie `examples/aws-env.example` para um arquivo local fora do Git, preencha com as credenciais do Learner Lab e execute `source`.

```bash
source ./aws-env.local
aws sts get-caller-identity
```

## Fluxo de instalação do LAB na AWS Learner

```bash
./infra/scripts/preflight.sh
./infra/scripts/infra-plan.sh
./infra/scripts/infra-up.sh
./infra/scripts/infra-status.sh
./infra/scripts/deploy-materials.sh
./infra/scripts/infra-smoke-test.sh
```

Após a aula:

```bash
./infra/scripts/infra-down.sh
```

## Segurança

As credenciais AWS não ficam em nenhum arquivo Terraform, Terragrunt, shell script ou `.env` versionado. O provider AWS consome as credenciais diretamente do ambiente do shell.
