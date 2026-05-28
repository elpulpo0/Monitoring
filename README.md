# Monitoring d'infrastructure et de containers Docker avec alertes via Telegram

Ce dépôt contient une configuration complète pour mettre en place un système de monitoring. Il est basé sur :
- **Prometheus**
- **Grafana**
- **Node Exporter**
- **cAdvisor**
- **AlertManager**
- **Versus-Incident**

## 📌 Prérequis

- Docker et Docker Compose V2 installés sur votre machine.
- Un environnement Linux ou Mac (cAdvisor ne fonctionne pas sur Windows dans cette version)
- L'adresse IP ou le nom d'hôte de votre serveur (remplace `<SERVER_IP>` dans la suite)

## 📂 Structure du projet

```sh
monitoring/
│── alertmanager/
│   └── alertmanager.yml          # Configuration générale de AlertManager
│── grafana/
│   └── dashboards/               # Fichiers json des dashboards pré-installés
│   └── provisioning/
│   │   └── dashboards/
│   │   │   └── dashboards.yml    # Configuration des dashboards pour Grafana
│   │   └── datasources/
│   │   │   └── datasources.yml    # Configuration des sources pour Grafana
│── prometheus/
│   └── alerts.yml                # Configuration des alertes pour Prometheus
│   └── prometheus.yml            # Configuration générale de Prometheus
│── versus-incident/
│   └── config/
│   │   └── config.yaml           # Configuration générale de Versus-Incident
│   │   └── telegram_message.tmpl # Template pour la notification sur le client Telegram
│── .env                          # Variables liées au client pour les notifications, ici Telegram
│── docker-compose.yaml           # Déploiement des services avec Docker Compose
```

## Copier et éditer le fichier .env_example en .env

```sh
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=

GRAFANA_ADMIN_USER=
GRAFANA_ADMIN_PASSWORD=
```

## 🚀 Installation  

1. Clonez le dépôt :  

   ```sh
   git clone https://github.com/elpulpo0/Monitoring && cd Monitoring
   ```  

2. Démarrez les services :  

   ```sh
   docker-compose up -d --build
   ```  

3. Vérifiez que les conteneurs sont en cours d'exécution :  

   ```sh
   docker ps -a
   ```  

## 🔧 Configuration des services  

### Prometheus  

Le fichier `prometheus.yml` configure la collecte des métriques depuis :  
- **Prometheus** (`http://<SERVER_IP>:9090`)  
- **Grafana** (`http://<SERVER_IP>:3000`)  
- **Node Exporter** (`http://<SERVER_IP>:9100`)  
- **cAdvisor** (`http://<SERVER_IP>:8080`)  

Accès à l'interface Web de Prometheus : `http://<SERVER_IP>:9090`  

> En local, remplacez `<SERVER_IP>` par `localhost`.

### Grafana  

L'interface de **Grafana** est accessible via : `http://<SERVER_IP>:3000`  

> En local, remplacez `<SERVER_IP>` par `localhost`.  

Connectez-vous avec les identifiants inscrits dans votre fichier .env :  

## 📊 Installation des Dashboards  

**Les dashboards suivants sont déjà implémentés :**

- **Node Exporter Full** (ID: `1860`)
- **Docker Monitoring** (ID: `193`) :

**Pour en ajouter d'autres :**

- Visitez https://grafana.com/grafana/dashboards/
- Récupérez l'ID du dashboard que vous voulez installer
- Allez dans **Dashboards** > **Import**  
- Entrez l’ID de votre dashboard et cliquez sur **Load**  
- Sélectionnez la source de données **Prometheus** et cliquez sur **Import**  

## 📌 Ports exposés  

| Service          | Port | URL                          |
|------------------|------|------------------------------|
| Grafana          | 3000 | `http://<SERVER_IP>:3000`    |
| Prometheus       | 9090 | `http://<SERVER_IP>:9090`    |
| Node Exporter    | 9100 | `http://<SERVER_IP>:9100`    |
| cAdvisor         | 8080 | `http://<SERVER_IP>:8080`    |
| AlertManager     | 9093 | `http://<SERVER_IP>:9093`    |
| Versus-Incident  | 3001 | `http://<SERVER_IP>:3001`    |

## 🛑 Arrêter et supprimer les conteneurs  

Pour arrêter le monitoring :  

```sh
docker-compose down
```  

## 📝 Licence  

Ce projet est sous licence MIT.