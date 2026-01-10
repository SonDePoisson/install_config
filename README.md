# Install Config

Script d'installation automatique des outils de développement.

## Outils installés

Ce script installe et configure automatiquement :

- **zsh** - Shell moderne et puissant
- **curl** - Outil de transfert de données
- **git** - Système de contrôle de version
- **Tailscale** - VPN mesh sécurisé
- **Oh My Zsh** - Framework de configuration pour zsh (avec thème `af-magic`)
- **uv** - Gestionnaire de packages et environnements Python rapide

## Utilisation

```bash
chmod +x install-dev-tools.sh
./install-dev-tools.sh
```

Le script détecte automatiquement votre système d'exploitation (macOS ou Linux) et utilise les gestionnaires de paquets appropriés.

## Post-installation

### Démarrer Tailscale

```bash
sudo tailscale up
```

### Utiliser zsh

```bash
zsh
```

Ou définissez-le comme shell par défaut (le script vous le proposera) :

```bash
chsh -s $(which zsh)
```

## Compatibilité

- **macOS** : Utilise Homebrew
- **Linux** : Compatible avec apt-get, yum, et pacman
