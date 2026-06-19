# Terraform OIDC Hello Lambda

Projeto novo com uma Lambda Hello World em AWS, Terraform com backend remoto seguro e GitHub Actions com OIDC, sem credenciais AWS estaticas no repositório.

## O que este projeto entrega

- Lambda Node.js "hello world"
- Terraform com backend remoto em S3
- Lock de state em DynamoDB
- Criptografia do state com AWS KMS
- OIDC do GitHub para assumir roles AWS sem access keys
- CI para `terraform plan` em branches de trabalho e PRs
- CD para `terraform apply` no merge para `main`, protegido por GitHub Environment
- Teste dummy executado no CI
- Branch protection com aprovação obrigatória para merge

## Estrutura

- `lambda/`: código da função
- `tests/`: teste dummy e teste da Lambda
- `infra/bootstrap/`: fundação AWS para state e OIDC
- `infra/envs/prod/`: stack da Lambda
- `.github/workflows/`: CI e CD

## Fluxo recomendado

1. Executar o bootstrap localmente com credencial AWS administrativa.
2. Publicar o repositório no GitHub.
3. Gravar as variáveis do repositório com nomes do bucket, tabela, KMS e roles.
4. Rodar CI em branch de trabalho.
5. Abrir PR para `main`.
6. Aprovar o PR.
7. Fazer merge.
8. Aprovar o environment `prod`.
9. Workflow de apply assume a role de CD por OIDC e implanta a Lambda.

Enquanto as variáveis do repositório ainda não estiverem configuradas, o CI executa um `terraform plan` local com `-backend=false` e `-refresh=false` para validar a stack. Depois que o bootstrap for concluído e as variables forem gravadas no GitHub, o mesmo workflow passa a executar `plan` remoto real via OIDC.

O workflow de `apply` tambem fica protegido: se as variables de backend e role ainda nao existirem, o job nao tenta implantar nada. Assim o repositório pode nascer primeiro e a fundação AWS pode ser conectada em seguida sem quebrar a branch principal.

No modo de fallback local, o provider AWS roda com validações de credencial e de metadata desabilitadas apenas para o CI sintático do branch. No fluxo normal de OIDC, essas flags continuam desligadas e a autenticação real acontece pela role assumida no GitHub Actions.

## Pré-requisitos

- AWS CLI autenticado
- Terraform >= 1.5
- Node.js >= 20
- GitHub CLI autenticado

## Bootstrap local

```bash
cd infra/bootstrap
terraform init
terraform apply \
  -var="github_owner=SEU_USUARIO" \
  -var="github_repo=terraform-oidc-hello-lambda" \
  -var="aws_region=us-east-2"
```

Se a conta AWS ja tiver um provider OIDC compartilhado do GitHub, reutilize assim:

```bash
terraform apply \
  -var="github_owner=SEU_USUARIO" \
  -var="github_repo=terraform-oidc-hello-lambda" \
  -var="create_github_oidc_provider=false" \
  -var="existing_github_oidc_provider_arn=arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
```

Anote estes outputs:

- `terraform_state_bucket_name`
- `terraform_lock_table_name`
- `terraform_state_kms_key_arn`
- `github_plan_role_arn`
- `github_apply_role_arn`

## Variáveis do GitHub

Defina no repositório:

- `AWS_REGION`
- `TF_STATE_BUCKET`
- `TF_LOCK_TABLE`
- `TF_STATE_KMS_KEY_ID`
- `AWS_ROLE_PLAN_ARN`
- `AWS_ROLE_APPLY_ARN`

## Implantação da stack

Após o bootstrap:

```bash
cd infra/envs/prod
terraform init \
  -backend-config="bucket=SEU_BUCKET" \
  -backend-config="key=prod/terraform.tfstate" \
  -backend-config="region=us-east-2" \
  -backend-config="dynamodb_table=SUA_TABELA" \
  -backend-config="kms_key_id=SEU_KMS_ARN" \
  -backend-config="encrypt=true"
terraform plan
```

## Testes

```bash
npm test
```
