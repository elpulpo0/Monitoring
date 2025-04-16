# Monitoring d'infrastructure et de containers Docker avec alertes via Telegram

Ce dépôt contient une configuration complète pour mettre en place un système de monitoring. Il est basé sur :
- **Prometheus**
- **Grafana**
- **Node Exporter**
- **cAdvisor**
- **AlertManager**
- **Versus-Incident**

## 📌 Prérequis

- Docker et Docker Compose installés sur votre machine.
- Un environnement Linux ou Mac (cAdvisor ne fonctionne pas sur Windows dans cette version)

## 📂 Structure du projet

```sh
monitoring/
│── alertmanager/
│   └── alertmanager.yml  # Configuration générale de AlertManager
│── prometheus/
│   └── alerts.yml # Configuration des alertes pour Prometheus
│   └── prometheus.yml  # Configuration générale de Prometheus
│── versus-incident/
│   └── config/
│   │   └── config.yaml # Configuration générale de Versus-Incident
│   │   └── telegram_message.tmpl # Template pour la notification sur le client Telegram
│── .env # Variables liées au client pour les notifications, ici Telegram
│── docker-compose.yaml  # Déploiement des services avec Docker Compose
```

## 🚀 Installation  

1. Clonez le dépôt :  

   ```sh
   git clone https://github.com/elpulpo0/Monitoring && cd monitoring
   ```  

2. Démarrez les services :  

   ```sh
   docker-compose up -d --build
   ```  

3. Vérifiez que les conteneurs sont en cours d'exécution :  

   ```sh
   docker ps -a
   ```  

## Copier et éditer le fichier .env_example en .env

```sh
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=
```

## 🔧 Configuration des services  

### Prometheus  

Le fichier `prometheus.yml` configure la collecte des métriques depuis :  
- **Prometheus** (`http://localhost:9090`)  
- **Grafana** (`http://localhost:3000`)  
- **Node Exporter** (`http://localhost:9100`)  
- **cAdvisor** (`http://localhost:8080`)  

Accès à l'interface Web de Prometheus : [http://localhost:9090](http://localhost:9090)  

### Grafana  

L'interface de **Grafana** est accessible via : [http://localhost:3000](http://localhost:3000)  

1. Connectez-vous avec les identifiants par défaut :  
   - **Utilisateur** : `admin`  
   - **Mot de passe** : `admin` (à modifier après la première connexion)  

2. Ajoutez Prometheus comme source de données :  
   - Allez dans **Configuration** > **Data Sources**  
   - Cliquez sur **Add data source**  
   - Sélectionnez **Prometheus**  
   - Configurez l’URL : `http://prometheus:9090`
   - Cliquez sur **Save & Test**  

## 📊 Installation des Dashboards  

Ajoutez les dashboards Grafana suivants :  

1. **Node Exporter Full** (ID: `1860`) :  
   - Allez dans **Dashboards** > **Import**  
   - Entrez l’ID `1860` et cliquez sur **Load**  
   - Sélectionnez la source de données **Prometheus** et cliquez sur **Import**  

2. **Docker Monitoring** (ID: `193`) :  
   - Répétez la procédure avec l’ID `193`  

## 📌 Ports exposés  

| Service          | Port |
|------------------|------|
| Grafana          | 3000 |
| Prometheus       | 9090 |
| Node Exporter    | 9100 |
| cAdvisor         | 8080 |
| alertmanager     | 9093 |
| versus-incident  | 3001 |

## 🛑 Arrêter et supprimer les conteneurs  

Pour arrêter le monitoring :  

```shdocker-compose down```  

## 📝 Licence  

Ce projet est sous licence MIT.  
