# Aplicativo PHP com RDS e SNS

Aplicativo Web PHP de exemplo para armazenar informações de contato.

O aplicativo usa [AWS RDS](https://aws.amazon.com/rds/) para armazenar informações de contato.

## Arquitetura alvo

![Notifier](/images/target_architecture.png)

## Passo-a-passo

### **Criar Rede**

01. Faça login no Console da AWS.

02. Em **Serviços**, digite **VPC** e selecione o serviço.

03. Selecione **Criar VPC** e preencha com os parâmetros abaixo.

    - Recursos a serem criados: **VPC e muito mais**
    - Gerar automaticamente: **db**
    - Bloco CIDR IPv4: **30.0.0.0/16**
    - Número de Zonas de Disponibilidade (AZs): **2**
    - Personalizar AZs
      - Primeira zona de disponibilidade: **us-east-1a**
      - Segunda zona de disponibilidade: **us-east-1b**
    - Número de sub-redes públicas: **2**
    - Número de sub-redes privadas: **2**
    - Personalizar blocos CIDR das sub-redes
      - Bloco CIDR da sub-rede pública em us-east-1a: **30.0.1.0/24**
      - Bloco CIDR da sub-rede pública em us-east-1b: **30.0.3.0/24**
      - Bloco CIDR da sub-rede privada em us-east-1a: **30.0.2.0/24**
      - Bloco CIDR da sub-rede privada em us-east-1b: **30.0.4.0/24**
    - Gateways NAT (USD): **Nenhuma**
    - Endpoints da VPC: **Nenhuma**
    
04. Clique em **Criar VPC**.

### **Criar Firewall**

#### **Firewall Público**

01. Em **Serviços**, digite **VPC** e selecione o serviço.

02. No menu lateral esquerdo, clique em **Grupos de segurança**.

03. Clique em **Criar grupo de segurança** e preencha com os parâmetros abaixo.

    - Nome do grupo de segurança: **db-sg-pub**
    - Descrição: **Grupo de Segurança DB público**
    - VPC: **db-vpc**
    - Regras de entrada (Clique em **Adicionar regra** para cada regra abaixo)
      - Regra 1
        - Tipo: **Todo o tráfego**
        - Origem: **30.0.0.0/16**
      - Regra 2
        - Tipo: **HTTP**
        - Origem: **0.0.0.0/0**
      - Regra 3
        - Tipo: **SSH**
        - Origem: **0.0.0.0/0**

04. Clique em **Criar grupo de segurança**.

#### **Firewall Privado**

01. Em **Serviços**, digite **VPC** e selecione o serviço.

02. No menu lateral esquerdo, clique em **Grupos de Segurança**.

03. Clique em **Criar grupo de segurança** e preencha com os parâmetros abaixo.

    - Nome do grupo de segurança: **db-sg-priv**
    - Descrição: **Grupo de Segurança DB privado**
    - VPC: **db-vpc**
    - Regras de entrada (Clique em **Adicionar regra**)
      - Regra 1
        - Tipo: **Todo o tráfego**
        - Origem: **30.0.0.0/16**

04. Clique em **Criar grupo de segurança**.

### **Criar Banco de Dados**

01. Em **Serviços**, digite **RDS** e selecione o serviço **Aurora and RDS**.

#### **Criar Grupo de Sub-redes**

01. No menu lateral esquerdo, clique em **Grupos de sub-redes**.

02. Clique em **Criar grupo de sub-redes de banco de dados** e preencha com os parâmetros abaixo.

    - Nome: **db-sn-group**
    - Descrição: **Grupo de Sub-redes do BD**
    - VPC: **db-vpc**
    - Zonas de Disponibilidade: **us-east-1a** e **us-east-1b**
    - Sub-redes: **30.0.2.0/24** e **30.0.4.0/24**

03. Clique em **Criar**.

#### **Criar Grupo de Parâmetros**

01. No menu lateral esquerdo, clique em **Grupos de parâmetros**.

02. Clique em **Criar grupo de parâmetros** e preencha com os parâmetros abaixo.

    - Nome do grupo de parâmetros: **db-param-group**
    - Descrição: **Grupo de Parâmetros do BD**
    - Tipo de mecanismo: **MySQL Community**
    - Família do grupo de parâmetros: **mysql8.0**

03. Clique em **Criar**.

#### **Configurar Grupo de Parâmetros para o parâmetro character_set_server**

01. No menu lateral esquerdo, clique em **Grupos de parâmetros**.

02. Clique no link **db-param-group**.

03. Clique em **Editar**.

04. No campo de busca **Parâmetros modificáveis**, digite **character_set_server**.

05. No campo **Valor**, digite **utf8**.

06. Clique em **Salvar alterações**.

#### **Configurar Grupo de Parâmetros para o parâmetro character_set_database**

01. No menu lateral esquerdo, clique em **Grupos de parâmetros**.

02. Clique no link **db-param-group**.

03. Clique em **Editar**.

04. No campo de busca **Parâmetros modificáveis**, digite **character_set_database**.

05. No campo **Valor**, digite **utf8**.

06. Clique em **Salvar alterações**.

#### **Criar banco de dados**

01. No menu lateral esquerdo, clique em **Bancos de dados**.

02. Clique em **Criar banco de dados** e preencha com os parâmetros abaixo.

    - Opções do mecanismo
      - Tipo de mecanismo: **MySQL**
    - Disponibilidade e durabilidade
      - Opções de implantação: **Implantação de instância de banco de dados Multi-AZ (2 instâncias)**
    - Configurações
      - Identificador da instância de banco de dados: **db-instance-id**
      - Nome do usuário principal: **dbadmin**
      - Gerenciamento de credenciais
        - Autogerenciada: **selecionado**
        - Senha principal: **dbpassword**
        - Confirmar senha principal: **dbpassword**
    - Configuração da instância
      - Classe da instância de BD: **Classes com capacidade de intermitência (inclui classes t)**
    - Armazenamento
      - Tipo de armazenamento: **gp2**
      - Configuração adicional de armazenamento
        - Habilitar escalonamento automático de armazenamento: **desabilitado**
    - Conectividade
      - Nuvem privada virtual (VPC): **db-vpc**
      - Grupo de sub-redes de banco de dados: **db-sn-group**
      - Grupos de segurança da VPC existentes: **db-sg-priv**

        > **Nota:** Remova o grupo de segurança **default** se selecionado.

    - Monitoramento
      - Monitoramento do Enhanced Monitoring: **desabilitado**
    - Configuração adicional
      - Nome do banco de dados inicial: **dbname**
      - Grupo de parâmetros do banco de dados: **db-param-group**
      - Habilitar backups automáticos: **desabilitado**
      - Habilitar criptografia: **desabilitado**
      - Habilitar o upgrade automático da versão secundária: **desabilitado**
      - Habilitar proteção contra exclusão: **desabilitado**

03. Clique em **Criar banco de dados**.

    > **Nota:** Valide a criação do banco de dados. O processo deve levar de 10 a 15 minutos. Aguarde até que o status seja **Disponível**.

04. Clique no link com **db-instance-id** e capture o valor do campo **Endpoint**.

    > **Nota:** Ele será usado em etapas posteriores.

### **Criar Balanceador de Carga com Escalonamento Automático**

#### **Criar Modelo de Inicialização do EC2**

01. Em **Serviços**, digite **EC2** e selecione o serviço.

02. No menu lateral esquerdo, em **Instâncias**, clique em **Modelos de execução**.

04. Selecione **Criar modelo de execução** e preencha com os parâmetros abaixo.

    - Nome do modelo de inicialização: **ec2-launch-template**
    - Imagens de aplicação e de sistema operacional (imagem de máquina da Amazon)
      - Início rápido: **Amazon Linux**
      - Imagem de máquina da Amazon (AMI): **Amazon Linux 2 AMI (HVM)**
    - Tipo de instância: **t2.micro**
    - Nome do par de chaves: **vockey** (ou qualquer outro de sua escolha)
    - Configurações de rede
      - Grupos de segurança: **db-sg-pub**
      - Configuração avançada de rede
        - Adicionar interface de rede
          - Atribuir IP público automaticamente: **Habilitar**
    - Detalhes avançados
      - Dados do usuário (opcional)

        ```
        #!/bin/bash
        
        # Update/Install required OS packages
        yum update -y
        yum install -y httpd wget php-fpm php-mysqli php-json php php-devel telnet tree git
        amazon-linux-extras install -y php7.2 epel
        yum install -y mysql php-mtdowling-jmespath-php php-xml
        
        # Config PHP app Connection to Database
        cat <<EOT >> /var/www/config.php
        <?php
        define('DB_SERVER', 'RDS_ENDPOINT');
        define('DB_USERNAME', 'dbadmin');
        define('DB_PASSWORD', 'dbpassword');
        define('DB_DATABASE', 'dbname');
        ?>
        EOT
        
        # Deploy PHP app
        cd /tmp
        git clone https://github.com/kledsonhugo/app-notifier
        cp /tmp/app-notifier/*.php /var/www/html/
        rm -rf /tmp/app-notifier
        
        # Config Apache WebServer
        usermod -a -G apache ec2-user
        chown -R ec2-user:apache /var/www
        chmod 2775 /var/www
        find /var/www -type d -exec chmod 2775 {} \;
        find /var/www -type f -exec chmod 0664 {} \;
        
        # Start Apache WebServer
        systemctl enable httpd
        service httpd restart
        ```

        > **Nota:** Substitua **RDS_ENDPOINT** pelo valor do endpoint do serviço RDS capturado nas etapas anteriores.
    
05. Clique em **Criar modelo de execução**.

#### **Criar Grupos do Auto Scaling**

01. No menu lateral esquerdo, em **Auto Scalling**, clique em **Grupos Auto Scaling**.

02. Selecione **Criar grupo do Auto Scaling** e preencha com os parâmetros abaixo.

    - Nome do grupo do Auto Scaling: **ec2-auto-scaling-group**
    - Modelo de execução: **ec2-launch-template**

03. Clique em **Próximo**.

04. Preencha com os parâmetros abaixo.

    - VPC: **db-vpc**
    - Zonas de Disponibilidade e sub-redes: **30.0.1.0/24** e **30.0.3.0/24**

05. Clique em **Próximo**.

06. Preencha com os parâmetros abaixo.

    - Balanceamento de carga
      - **Anexar a um novo balanceador de carga**
    - Anexar a um novo balanceador de carga
      - Nome do balanceador de carga: **ec2-load-balancer**
      - Esquema do balanceador de carga: **Internet-facing**
      - Listeners e roteamento
        - Roteamento padrão (encaminhar para): **Criar um grupo de destino**
        - Nome do novo grupo de destinos: **ec2-target-group**

07. Clique em **Próximo**.

08. Preencha com os parâmetros abaixo.

    - Tamanho do grupo
      - Capacidade desejada: **2**

09. Clique em **Próximo**.

10. Clique em **Próximo**.

11. Clique em **Próximo**.

12. Clique em **Criar grupo do Auto Scaling**.

#### **Configurar Grupo de Segurança do Balanceador de Carga**

01. No menu lateral esquerdo, em **Balanceamento de Carga**, clique em **Load balancers**.

02. Clique em **ec2-load-balancer** para abrir a página de detalhes do Balanceador de Carga.

03. Clique no menu **Segurança**.

04. Clique em **Editar**.

05. Remova o Grupo de Segurança padrão e adicione **db-sg-pub**.

06. Clique em **Salvar Alterações**.

#### **Validar Grupo de Destino**

01. No menu lateral esquerdo, em **Balanceamento de Carga**, clique em **Grupos de Destino**.

02. Clique em **ec2-target-group** e valide se 2 instâncias estão com status **Íntegro**.

    > **Nota:** O processo de registro das instâncias leva de 5 a 10 minutos.

#### **Validar Balanceador de Carga**

01. No menu lateral esquerdo, em **Balanceamento de Carga**, clique em **Load balancers**.

02. Clique em **ec2-load-balancer** e capture o valor do campo **Nome DNS**.

03. Abra uma aba no navegador e navegue para **http://NOME_DNS**. Substitua **NOME_DNS** pelo valor capturado na etapa anterior.

    > **Nota:** Você deve ver uma página como o exemplo abaixo. Adicione um novo contato para validar que o aplicativo web PHP está adicionando dados no RDS com sucesso.

      ![Notifier](/images/notifier.png)

## **Parabéns**

Se você chegou até aqui com sucesso, completou o procedimento.

Não se esqueça de destruir todos os recursos para evitar custos desnecessários.
