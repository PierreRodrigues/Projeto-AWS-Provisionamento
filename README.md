# Provisionamento de Infraestrutura AWS com CloudFormation e Terraform

Este repositório contém templates e scripts para provisionar uma infraestrutura web escalável e resiliente na Amazon Web Services (AWS), utilizando tanto AWS CloudFormation quanto HashiCorp Terraform.

## Tabela de Conteúdos

*   [Sobre o Projeto](#sobre-o-projeto)
*   [Recursos Provisionados](#recursos-provisionados)
*   [Estrutura do Projeto](#estrutura-do-projeto)
*   [Pré-requisitos](#pré-requisitos)
*   [Como Usar](#como-usar)
    *   [CloudFormation](#cloudformation)
    *   [Terraform](#terraform)
*   [Contribuidores](#contribuidores)
*   [Licença](#licença)

## Sobre o Projeto

O objetivo deste projeto é demonstrar as melhores práticas para automação de infraestrutura como código (IaC), provisionando um ambiente web completo que inclui instâncias EC2, Auto Scaling, Load Balancing e regras de segurança. A infraestrutura é projetada para ser altamente disponível, distribuindo os recursos em múltiplas Zonas de Disponibilidade (AZs).

O repositório oferece duas implementações distintas para atingir o mesmo objetivo, permitindo a comparação entre as abordagens do AWS CloudFormation e do Terraform.

## Recursos Provisionados

A arquitetura provisionada consiste nos seguintes componentes:

*   **Amazon Virtual Private Cloud (VPC):** Uma VPC customizada com sub-redes públicas em duas AZs para garantir alta disponibilidade.
*   **Amazon EC2:** Instâncias Linux que servem como servidores web.
*   **Elastic Load Balancer (ELB):** Um Application Load Balancer (ALB) para distribuir o tráfego de entrada entre as instâncias EC2.
*   **Auto Scaling Group:** Garante que o número de instâncias EC2 se ajuste automaticamente à demanda, com base no uso de CPU.
*   **Security Groups:** Regras de firewall que seguem o princípio do menor privilégio, permitindo apenas o tráfego necessário (HTTP e SSH).
*   **Internet Gateway e Route Tables:** Para permitir a comunicação entre a VPC e a internet.

## Estrutura do Projeto

O repositório está organizado da seguinte forma:

```
/Projeto-AWS-Provisionamento
|-- /Projeto-em-CloudFormation
|   |-- Auto-Scaling.yaml
|   |-- EC2.yaml
|   |-- Load-Balance.yaml
|   |-- Parameters.yaml
|   |-- Security-Groups.yaml
|   `-- ecs.yaml
`-- /Projeto-em-Terraform/AWS-Cloud
    |-- main.tf
    |-- outputs.tf
    |-- userdata.sh
    `-- variables.tf
```

*   **`Projeto-em-CloudFormation/`**: Contém os templates YAML do AWS CloudFormation, divididos por recurso para melhor modularidade.
*   **`Projeto-em-Terraform/AWS-Cloud/`**: Contém os arquivos de configuração do Terraform (`.tf`) para provisionar a mesma infraestrutura.

## Pré-requisitos

Antes de começar, certifique-se de ter as seguintes ferramentas instaladas e configuradas:

*   [AWS CLI](https://aws.amazon.com/cli/): Configurado com as suas credenciais da AWS (`aws configure`).
*   [Terraform](https://www.terraform.io/downloads.html): Se for utilizar a implementação com Terraform.

## Como Usar

### CloudFormation

Para provisionar a infraestrutura usando CloudFormation, você pode criar uma stack principal que orquestra a criação dos recursos a partir dos templates aninhados. Siga os passos abaixo:

1.  **Navegue até o diretório do CloudFormation:**

    ```bash
    cd Projeto-em-CloudFormation
    ```

2.  **Crie a stack na AWS:**

    Você pode fazer o deploy através da console da AWS ou utilizando a AWS CLI. Para a CLI, você precisará de um template "mestre" que chame os demais, ou fazer o deploy de cada um na ordem correta de dependências (VPC, Security Groups, EC2, Load Balancer, Auto Scaling).

    *Exemplo de comando para criar uma stack (ajuste conforme necessário):*

    ```bash
    aws cloudformation create-stack --stack-name MinhaStackWebApp --template-body file://seu-template-mestre.yaml --parameters file://seus-parametros.json
    ```

### Terraform

Para provisionar a infraestrutura com Terraform, siga os passos abaixo:

1.  **Navegue até o diretório do Terraform:**

    ```bash
    cd Projeto-em-Terraform/AWS-Cloud
    ```

2.  **Inicialize o Terraform:**

    Este comando inicializa o diretório de trabalho, baixando os provedores necessários.

    ```bash
    terraform init
    ```

3.  **Planeje a execução:**

    O Terraform irá criar um plano de execução para que você possa revisar os recursos que serão criados.

    ```bash
    terraform plan
    ```

4.  **Aplique as configurações:**

    Este comando aplica as configurações e provisiona os recursos na sua conta AWS.

    ```bash
    terraform apply
    ```

    Você será solicitado a confirmar a aplicação do plano. Digite `yes` para continuar.

5.  **Destrua a infraestrutura:**

    Quando não precisar mais da infraestrutura, você pode destruí-la com o comando:

    ```bash
    terraform destroy
    ```

## Contribuidores

*   **Pierre Rodrigues**
*   **Nando Cardoso**
*   **Maria Silveira**
