# Docker Operations (Guia Prático)

Este guia tem como objetivo capacitar os formandos a **compreender Docker desde os conceitos fundamentais até à criação e distribuição de imagens**, com foco em uso prático no desenvolvimento moderno e em ambientes DevSecOps.

---

## Índice

1. [O que é Docker](#1️⃣-o-que-é-docker)
2. [Docker vs Máquina Virtual (VM)](#2️⃣-docker-vs-máquina-virtual-vm)
3. [Conceitos Essenciais do Docker](#3️⃣-conceitos-essenciais-do-docker)
4. [Arquitetura Docker](#4️⃣-arquitetura-docker)
5. [Instalação do Docker](#4️⃣-instalação-do-docker)
6. [Comandos Docker Básicos](#5️⃣-comandos-docker-básicos)
7. [Trabalhar com Containers (`docker run`)](#6️⃣-trabalhar-com-containers-docker-run)
8. [Volumes](#7️⃣-volumes)
9. [Redes Docker](#8️⃣-redes-docker)
10. [Docker Compose (uso prático)](#9️⃣-docker-compose-uso-prático)
11. [Dockerfile (definição da imagem)](#🔟-dockerfile-definição-da-imagem)
12. [Docker Build (criar a imagem)](#1️⃣1️⃣-docker-build-criar-a-imagem)
13. [Docker Registry (armazenar a imagem)](#1️⃣2️⃣-docker-registry-armazenar-a-imagem)
14. [Docker e Segurança](#1️⃣3️⃣-docker-e-segurança)
15. [Exercícios Práticos](#-exercícios-práticos)
16. [Documentação Oficial](#-documentação-oficial)

---

## 1️⃣ O que é Docker?

O **Docker** é uma plataforma que permite **empacotar e executar aplicações em containers**.

Um container inclui:

* a aplicação
* as dependências
* as bibliotecas necessárias
* configurações básicas

O objetivo principal do Docker é garantir que:

> *“A aplicação funciona da mesma forma em qualquer ambiente.”*

Docker **não é uma máquina virtual**.

Documentação: [https://docs.docker.com/get-started/](https://docs.docker.com/get-started/)

---

## 2️⃣ Docker vs Máquina Virtual (VM)

| Docker              | Máquina Virtual (VM) |
| --------------------| ---------------- |
| Partilha kernel com o host  | Possui Kernel próprio |
| Executa aplicações isoladas | Executa um sistema operativo completo |
| Arranque Rápido           | Arranque Lento            |
| Muito mais Leve             |  Pesada - Consome mais recursos (CPU, RAM, disco) |
| Isola aplicações | Isola SO inteiro |

| |  | |
|---------------------| ---- | ----------------------|
| ![Docker](https://docker.com/app/uploads/2021/11/docker-containerized-appliction-blue-border_2.png) | VS |  ![VM](https://www.docker.com/app/uploads/2021/11/container-vm-whatcontainer_2.png) |

**Simples e Direta:**
> VM virtualiza o sistema operativo\
> Docker virtualiza a aplicação

---

## 3️⃣ Conceitos Essenciais do Docker

### Imagem

* É um **modelo (template)** da aplicação
* É imutável (read-only)
* Serve de base para criar containers

Exemplos:

```text
nginx
python:3.12
postgres:15
```

---

### Container

* É uma **imagem em execução**
* Pode ser iniciado, parado ou removido
* Não guarda dados permanentemente

Se o container for removido, os dados internos perdem-se.

---

### Volume

* Mecanismo de **persistência de dados**
* Os dados sobrevivem à remoção do container
* Usado para bases de dados, uploads, logs

---

### Rede

* Permite comunicação entre containers
* Containers na mesma rede comunicam-se pelo `nome` ou `containar_id`

Exemplo:

```text
web → db:5432
```

---

## 4️⃣ Arquitetura Docker

O Docker utiliza uma arquitetura `cliente–servidor`.
O cliente `docker` envia comandos e o `daemon Docker` é responsável por `construir, executar e gerir os containers`.

O `cliente` e o `daemon` podem estar:
- no mesmo sistema, ou
- em sistemas diferentes (daemon remoto)

\
A comunicação entre eles é feita através de:
- API REST
- sockets UNIX
- rede

O **Docker Compose** é outro `cliente` Docker, utilizado para gerir aplicações compostas por vários containers.

![Arquitetura](https://docs.docker.com/get-started/images/docker-architecture.webp)

---

## 5️⃣ Instalação do Docker

### Windows / macOS

Docker Desktop:
[https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)

### Linux / WSL2

[https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

Verificar instalação:

```bash
docker --version
docker compose version
```

---

## 6️⃣ Comandos Docker Básicos

```bash
docker pull nginx
docker push django_todolist:0.0.0
docker images
docker run
docker ps
docker ps -a
docker logs
docker stop container_id
docker rm container_id
docker build
docker volume 
docker network
docker compose
```

---

## 7️⃣ Trabalhar com Containers (`docker run`)

Executar um container simples:

```bash
docker run nginx
```

Executar com porta exposta:

```bash
docker run -p 8080:80 nginx
```

Executar em background:

```bash
docker run -d nginx
```

Ver logs:

```bash
docker logs container_id
```

Aceder ao container:

```bash
docker exec -it container_id sh
```

---

## 8️⃣ Volumes

Criar volume:

```bash
docker volume create dados
```

Usar volume:

```bash
docker run -v dados:/data nginx
```

Volumes garantem persistência de dados.

---

## 9️⃣ Redes Docker

Listar redes:

```bash
docker network ls
```

Criar rede:

```bash
docker network create webapp-network
```

Usar rede:

```bash
docker run --network webapp-network nginx
```

Comunicação entre containers depende da rede Docker.

---

## 🔟 Docker Compose (uso prático)

O **Docker Compose** permite executar **vários containers em conjunto**, ideal para desenvolvimento local e ambiente de validação.

Exemplo:

```yaml
version: "3.8" ### (Optional)

services:
  web:
    image: nginx
    ports:
      - "8080:80"

  db:
    image: postgres:18.1
    environment:
      POSTGRES_PASSWORD=postgres
```

Executar:

```bash
docker compose up -d
docker compose logs -f
docker compose down
```

Neste ponto estamos **a usar imagens existentes**, não a criar imagens novas.

[https://docs.docker.com/compose/](https://docs.docker.com/compose/)

---

## 1️⃣1️⃣ Dockerfile (definição da imagem)

O **Dockerfile** é um ficheiro de texto que define **como uma imagem deve ser construída**.

Exemplo:

```dockerfile
# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies needed for building packages
RUN apt-get update && apt-get install -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*

# Set PYTHONPATH to include the todolist_project directory
ENV PYTHONPATH=/app/todolist_project

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Copy and set permissions for the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the port the app runs on
EXPOSE 8000

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Command to run the application
CMD ["gunicorn", "config.wsgi:application", "-b", "0.0.0.0:8000", "--timeout", "120"]
```

O Dockerfile **descreve a imagem**, mas ainda não a cria.

---

## 1️⃣2️⃣ Docker Build (criar a imagem)

Após criar o Dockerfile, usamos `docker build` para **criar a imagem**.

Sem este passo, não existe imagem própria.

```bash
docker build -t django_todolist:0.0.0 .
```

Ver imagens criadas:

```bash
docker images
```

Executar a imagem criada sem mapear volume:
```bash
docker run --rm --name django_todolist -p 8000:8000 --env-file .env django_todolist:0.0.0
```

Alterar cotainer em execução, copiando ficheiros para o container:
```bash
docker cp todolist_project/templates/base.html django_todolist:/app/todolist_project/templates/base.html
```
Reiniar o container e verificar a alteração:
```bash
docker restart django_todolist
```

Eliminar o container e voltar a executar a imagem criada sem mapear volume, para ver a alteração:
```bash
docker rm -f django_todolist
```
```bash
docker run --rm --name django_todolist -p 8000:8000 --env-file .env django_todolist:0.0.0
```

Executar a imagem criada mapeando volume e voltar a alter ficheiro e constatar a alteração:
```bash
docker run --rm --name django_todolist -p 8000:8000 -v $(pwd):/app --env-file .env django_todolist:0.0.0
```

---

## 1️⃣3️⃣ Docker Registry (armazenar a imagem)

Depois de criada, a imagem deve ser **armazenada num Docker Registry**.

Um **Docker Registry** é um **repositório de imagens Docker**, usado para:
* armazenar imagens
* versionar imagens
* partilhar imagens entre equipas e ambientes
* integrar com CI/CD
* *Um registry é para imagens o que o GitHub ou GitLab é para código.*

Sempre que executas: ```docker pull```, estás a descarregar uma imagem de um **registry**.

**Doc:** [https://docs.docker.com/registry/](https://docs.docker.com/registry/)

### Exemplos de registries (público)

* Docker Hub (registry padrão do Docker): [https://hub.docker.com](https://hub.docker.com)
* GitHub Container Registry
* GitLab Container Registry

**Limitações:**

* limites de imagens privados
* limites de build (CI/CD)
* não recomendado para ambientes corporativos sensíveis


## Docker Registry em ambientes corporativos (Privado)

Em empresas e projetos institucionais, é comum usar **registries privados**, por razões de:

* segurança
* controlo de acesso
* soberania dos dados
* integração com CI/CD
* ambientes on-premise/controlado

### Open-source / On-Premise (recomendado para instituições)

* Harbor (muito utilizado)
* Docker Registry (`registry:2`)
* GitLab Container Registry (self-hosted)
* Quay (Red Hat)

#### Exercicio: Utilizar registry publico:
* Criar conta em Docker Hub [https://hub.docker.com](https://hub.docker.com)
* Criar repositório no Docker Hub
* Efetuar login no Docker Hub no terminal (Requerer ```token``` de acesso ao repositório no Docker Hub)
* Criar ```tag``` da imagem criada (`:0.0.0`)
```bash
docker tag django_todolist:0.0.0 your_username/django_todolist:0.0.0
```
* Push para registry
```bash
docker push your_username/django_todolist:0.0.0
```
* Remover imagem local
```bash
docker rmi your_username/django_todolist:0.0.0
```
* Testar pull da imagem
```bash
docker pull your_username/django_todolist:0.0.0
```

#### Exemplo de registry local:

```bash
docker run --name=registry2 -d -p 5001:5000 \
  --network webapp-network \
  -e REGISTRY_HTTP_HEADERS_Access-Control-Allow-Origin="['http://localhost:8083']" \
  -e REGISTRY_HTTP_HEADERS_Access-Control-Allow-Methods='[HEAD,GET,OPTIONS,DELETE]' \
  -e REGISTRY_HTTP_HEADERS_Access-Control-Allow-Headers='[Authorization,Accept,Cache-Control]' \
  -e REGISTRY_HTTP_HEADERS_Access-Control-Expose-Headers='[Docker-Content-Digest]' \
  -e REGISTRY_HTTP_HEADERS_Access-Control-Allow-Credentials='[true]' \
  -e REGISTRY_STORAGE_DELETE_ENABLED='true' \
  registry:2
```

Push:

```bash
docker tag django_todolist:0.0.0 localhost:5000/django_todolist:1.0
docker push localhost:5001/django_todolist:1.0
docker pull localhost:5000/django_todolist:1.0
```
Listar imagens do registry no registry local
```bash
curl http://localhost:5000/v2/_catalog
````
Resposta:
```bash
{
  "repositories": [
    "django_todolist"
  ]
}
```

Listar tags de uma imagem:
```bash
http://localhost:5000/v2/django_todolist/tags/list
```
Resposta:
```bash
{
  "name": "django_todolist",
  "tags": [
    "1.1",
    "1.0"
  ]
}
```

Docker Registry UI (joxit):
```bash
docker run --rm --name=registry-ui -d \
  -p 8080:80 \
  --network webapp-network \
  -e REGISTRY_TITLE="Local Docker Registry" \
  -e REGISTRY_URL=http://localhost:5000 \
  joxit/docker-registry-ui
```

Aceder registry UI na porta `8080`: http://localhost:8080

---

## 1️⃣4️⃣ Docker e Segurança

Boas práticas:

* utilizar imagens oficiais
* evitar `latest`
* utilizar `.env` para segredos
* scan de imagens (Trivy, Snyk)
* utilizar registries privados
* autenticação e autorização
* versionar imagens (`:v1`, `:v2`, nunca só `latest`)
* restringir quem pode fazer `push`

Em ambientes DevSecOps, **a imagem também é código**.

[https://docs.docker.com/engine/security/](https://docs.docker.com/engine/security/)

---

## Exercícios Práticos

1. Executar nginx com `docker run`
2. Criar volume e persistir dados
3. Criar rede Docker
4. Subir serviços com Docker Compose
5. Criar Dockerfile
6. Construir imagem com `docker build`
7. Push para registry local ou publico

---

## Documentação Oficial

* Docker: [https://docs.docker.com](https://docs.docker.com)
* Dockerfile: [https://docs.docker.com/engine/reference/builder/](https://docs.docker.com/engine/reference/builder/)
* Docker Compose: [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
* Docker Registry: [https://docs.docker.com/registry/](https://docs.docker.com/registry/)
* Harbor: [https://goharbor.io/docs/](https://goharbor.io/docs/)
* GitHub Container Registry: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
* GitLab Registry: https://docs.gitlab.com/ee/user/packages/container_registry/
---

## Nota Final

Este README serve como:

* guia de formação
* material de apoio
* referência prática pós-formação

Aproveite!