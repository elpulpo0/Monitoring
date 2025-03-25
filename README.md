# Monitoring avec Prometheus, Grafana, Node Exporter et cAdvisor

Ce dépôt contient une configuration complète pour mettre en place un système de monitoring basé sur **Prometheus**, **Grafana**, **Node Exporter** et **cAdvisor**.

## 📌 Prérequis

- Docker et Docker Compose installés sur votre machine.

## 📂 Structure du projet

```sh
monitoring/
│── prometheus/
│   └── prometheus.yml  # Configuration de Prometheus
│── docker-compose.yaml  # Déploiement des services avec Docker Compose
```


## 🚀 Installation  

1. Clonez le dépôt :  

   ```sh
   git clone https://github.com/elpulpo0/Monitoring && cd Monitoring
   ```  

2. Démarrez les services :  

   ```sh
   docker-compose up -d
   ```  

3. Vérifiez que les conteneurs sont en cours d'exécution :  

   ```sh
   docker ps
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

| Service       | Port  |  
|--------------|------|  
| Grafana      | 3000 |  
| Prometheus   | 9090 |  
| Node Exporter | 9100 |  
| cAdvisor     | 8080 |  

## 🛑 Arrêter et supprimer les conteneurs  

Pour arrêter le monitoring :  

```shdocker-compose down```  

## 📝 Licence  

Ce projet est sous licence MIT.  
