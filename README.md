# Configuração AWS para Workflow de Deploy Automatizado

Para executar o workflow de deploy de uma aplicação em uma instância EC2 usando GitHub Actions, é necessário configurar adequadamente a AWS. Abaixo estão as etapas essenciais para garantir o acesso e permissões necessários.

---

## 1. Política IAM e Permissões

Crie uma política IAM personalizada para o usuário `github-actions-deploy` com permissões limitadas, garantindo apenas o acesso essencial:

- **Instâncias EC2**:
  - Gerenciar instâncias: `RunInstances`, `DescribeInstances`, `TerminateInstances`.
  - Função: Criação, descrição e encerramento das instâncias necessárias para o deploy.

- **Pares de Chaves**:
  - Gerenciamento de chaves SSH temporárias: `CreateKeyPair`, `DeleteKeyPair`, `DescribeKeyPairs`.
  - Função: Criação e exclusão de chaves SSH usadas para acesso seguro à instância.

- **Grupos de Segurança**:
  - Visualizar grupos de segurança: `DescribeSecurityGroups`.
  - Função: Verificação das configurações de rede associadas à instância EC2.

- **Imagens e Regiões**:
  - Acesso à AMI e configuração regional: `DescribeImages`, `DescribeRegions`.
  - Função: Identificação da AMI do Ubuntu e da região AWS para o deploy.

- **Tags**:
  - Gerenciamento de tags: `CreateTags`, `DeleteTags`.
  - Função: Facilitar a organização e o monitoramento das instâncias.

Anexe essa política ao usuário `github-actions-deploy` para garantir que ele tenha permissões restritas e necessárias.

---

## 2. Criação de Chaves de Acesso (Access Key e Secret Key)

Para que o GitHub Actions possa se autenticar na AWS, gere chaves de acesso para o usuário `github-actions-deploy`:

1. **Geração de Chaves de Acesso**:
   - No Console AWS, acesse o perfil do usuário IAM e vá para **Credenciais de segurança**.
   - Clique em **Criar chave de acesso** e salve o **Access Key ID** e o **Secret Access Key**.

2. **Uso Restrito**:
   - Assegure-se de que essas chaves sejam usadas apenas para o workflow no GitHub Actions e que o usuário `github-actions-deploy` seja exclusivo para automação.

---

## 3. Configuração do Security Group

É necessário configurar um Security Group para controlar o tráfego de rede na instância EC2:

1. **Portas Necessárias**:
   - **Porta 22**: Necessária para SSH e execução remota de comandos durante o deploy.
   - **Porta 8080**: Porta onde a API estará escutando e deverá ser acessível publicamente.

2. **Associação com a Instância EC2**:
   - O ID do Security Group (`AWS_SECURITY_GROUP`) será referenciado no workflow. Verifique se ele está corretamente associado à instância EC2 para garantir o acesso adequado.

---

## 4. Configuração dos Secrets no GitHub

No repositório GitHub onde o workflow está configurado, adicione os secrets para permitir que o GitHub Actions acesse os recursos AWS com segurança.

1. **Acesso às Configurações de Secrets**:
   - No repositório, vá para **Settings > Secrets and variables > Actions** e clique em **New repository secret**.

2. **Defina os Secrets**:
   - **AWS_ACCESS_KEY_ID**: Cole o Access Key ID gerado.
   - **AWS_SECRET_ACCESS_KEY**: Cole o Secret Access Key.
   - **AWS_REGION**: Especifique a região AWS onde a instância EC2 será criada (por exemplo, `us-east-1`).
   - **AWS_SECURITY_GROUP**: ID do Security Group configurado para permitir o tráfego na instância (porta 22 para SSH e porta 8080 para a API).

Esses secrets garantem que o GitHub Actions possa autenticar e realizar operações AWS com segurança.

---

## Resumo

Após configurar a política IAM, chaves de acesso e secrets no GitHub, o workflow de deploy no GitHub Actions terá os acessos necessários e seguros para gerenciar recursos EC2. Essas configurações permitem um deploy automatizado e seguro da aplicação na AWS.
