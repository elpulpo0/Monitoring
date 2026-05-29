# Monitoring d'infrastructure et de containers Docker avec alertes via Telegram

Ce dépôt contient une configuration complète pour mettre en place un système de monitoring. Il est basé sur :
- **Prometheus** : collecte des métriques
- **Grafana** : visualisation (métriques + logs)
- **Node Exporter** : métriques système (CPU, RAM, disque)
- **cAdvisor** : métriques containers Docker (auto-détection de tous les containers)
- **Loki** : agrégation des logs
- **Promtail** : collecte des logs Docker (auto-détection de tous les containers)
- **Blackbox Exporter** : surveillance des URLs HTTP externes
- **AlertManager** : routage des alertes
- **Versus-Incident** : envoi des notifications Telegram

## 📌 Prérequis

- Docker et Docker Compose V2 installés sur votre machine.
- Un environnement Linux ou Mac (cAdvisor ne fonctionne pas sur Windows dans cette version)
- L'adresse IP ou le nom d'hôte de votre serveur (remplace `<SERVER_IP>` dans la suite)

## 📂 Structure du projet

```sh
monitoring/
│── alertmanager/
│   └── alertmanager.yml          # Configuration générale de AlertManager
│── blackbox/
│   └── blackbox.yml              # Modules de sonde HTTP/TCP
│── grafana/
│   └── dashboards/               # Fichiers json des dashboards pré-installés
│   └── provisioning/
│   │   └── dashboards/
│   │   │   └── dashboards.yml    # Configuration des dashboards pour Grafana
│   │   └── datasources/
│   │   │   └── datasources.yml   # Configuration des sources pour Grafana
│── loki/
│   └── loki.yml                  # Configuration générale de Loki
│── prometheus/
│   └── alerts.yml                # Configuration des alertes pour Prometheus
│   └── entrypoint.sh             # Script de démarrage (substitution SERVER_NAME)
│   └── prometheus.yml            # Configuration générale de Prometheus
│── promtail/
│   └── promtail.yml              # Configuration collecte des logs Docker
│── versus-incident/
│   └── config/
│   │   └── config.yaml           # Configuration générale de Versus-Incident
│   │   └── telegram_message.tmpl # Template des notifications Telegram
│── .env                          # Credentials (non versionné)
│── .env_example                  # Exemple de fichier .env
│── config.yml                    # Configuration utilisateur (non versionné)
│── config.yml.example            # Exemple de fichier config.yml
│── docker-compose.yaml           # Déploiement des services avec Docker Compose
```

## ⚙️ Configuration

Deux fichiers à créer à partir des exemples fournis :

### `config.yml` : paramètres du serveur (non-sensible)

```sh
cp config.yml.example config.yml
```

```yaml
server_name: srv-prod-1        # Nom affiché dans les alertes Telegram

blackbox_targets:              # URLs à surveiller (alerte si inaccessible 2 min)
  - https://mon-service.example.com
```

> Donnez un `server_name` distinct sur chaque serveur.

### `.env` : credentials (sensible)

```sh
cp .env_example .env
```

```sh
TELEGRAM_BOT_TOKEN=        # Token du bot Telegram
TELEGRAM_CHAT_ID=          # ID du chat Telegram

GRAFANA_ADMIN_USER=        # Identifiant admin Grafana
GRAFANA_ADMIN_PASSWORD=    # Mot de passe admin Grafana
```

## 🚀 Installation

1. Clonez le dépôt :

   ```sh
   git clone https://github.com/elpulpo0/Monitoring && cd Monitoring
   ```

2. Créez et remplissez les fichiers de configuration :

   ```sh
   cp config.yml.example config.yml
   cp .env_example .env
   ```

3. Démarrez les services :

   ```sh
   docker compose up -d
   ```

4. Vérifiez que les conteneurs sont en cours d'exécution :

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
- **Loki** (`http://<SERVER_IP>:3100`)

Accès à l'interface Web de Prometheus : `http://<SERVER_IP>:9090`

> En local, remplacez `<SERVER_IP>` par `localhost`.

### Grafana

L'interface de **Grafana** est accessible via : `http://<SERVER_IP>:3000`

> En local, remplacez `<SERVER_IP>` par `localhost`.

Connectez-vous avec les identifiants définis dans votre fichier `.env`.

**Réinitialiser le mot de passe admin si besoin :**

```sh
docker exec -it monitoring_grafana grafana cli admin reset-admin-password 'NouveauMotDePasse'
```

### Loki + Promtail (logs)

Loki centralise les logs. Promtail les collecte automatiquement depuis tous les containers Docker via le socket Docker, aucune configuration manuelle n'est requise pour les nouveaux containers.

Pour consulter les logs dans Grafana : **Menu > Drilldown > Logs** → filtrer par `container`, `service` ou `project`.

### Blackbox Exporter (surveillance HTTP)

Ajoutez vos URLs dans `config.yml` sous `blackbox_targets` :

```yaml
blackbox_targets:
  - https://mon-service.example.com
  - https://api.example.com/health
```

Redémarrez Prometheus pour appliquer : `docker compose restart prometheus`

L'alerte `service_down` se déclenche si une URL est inaccessible pendant plus de 2 minutes.

## 🔔 Alertes

Les alertes suivantes sont configurées dans `prometheus/alerts.yml` :

| Alerte | Condition | Sévérité |
|--------|-----------|----------|
| `monitor_service_down` | Un service Prometheus est inaccessible | critical |
| `high_cpu_load` | Load average > 80% du nombre de cœurs pendant 5 min | warning |
| `high_memory_load` | Mémoire utilisée > 85% pendant 30s | warning |
| `high_storage_load` | Disque `/` utilisé > 85% pendant 30s | warning |
| `service_down` | Une URL surveillée (Blackbox) est inaccessible 2 min | critical |
| `container_down` | Un container n'a pas été vu depuis 60s | critical |

> `container_down` et les logs Promtail détectent **automatiquement tous les containers**, y compris les nouveaux - aucune configuration manuelle requise.

Les notifications sont envoyées sur Telegram via **Versus-Incident** et incluent : nom du serveur, sévérité, résumé, détail et horodatage.

## 📊 Dashboards

**Les dashboards suivants sont pré-installés :**

- **Node Exporter Full** (ID: `1860`) - métriques système
- **Docker Monitoring** (ID: `193`) - métriques containers

**Pour en ajouter d'autres :**

1. Visitez https://grafana.com/grafana/dashboards/
2. Récupérez l'ID du dashboard souhaité
3. Dans Grafana : **Dashboards** > **Import** > entrez l'ID > sélectionnez **Prometheus** > **Import**

## 📌 Ports exposés

| Service              | Port | URL                          |
|----------------------|------|------------------------------|
| Grafana              | 3000 | `http://<SERVER_IP>:3000`    |
| Prometheus           | 9090 | `http://<SERVER_IP>:9090`    |
| Node Exporter        | 9100 | `http://<SERVER_IP>:9100`    |
| cAdvisor             | 8080 | `http://<SERVER_IP>:8080`    |
| AlertManager         | 9093 | `http://<SERVER_IP>:9093`    |
| Versus-Incident      | 3001 | `http://<SERVER_IP>:3001`    |
| Loki                 | 3100 | `http://<SERVER_IP>:3100`    |
| Blackbox Exporter    | 9115 | `http://<SERVER_IP>:9115`    |

## 🔄 Mettre à jour les services

```sh
docker compose pull
docker compose up -d
```

> `docker compose up -d` seul ne met pas à jour les images déjà en cache. Le `pull` est nécessaire pour récupérer les dernières versions depuis Docker Hub.

## 🛑 Arrêter les services

```sh
docker compose down
```

## 📝 Licence

Ce projet est sous licence MIT.
