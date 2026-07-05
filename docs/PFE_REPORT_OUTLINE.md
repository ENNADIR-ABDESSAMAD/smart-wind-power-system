# Plan de rapport PFE — Système IoT Smart Wind Power

> Structure suggérée pour le mémoire de fin d'études (en français).

## Page de garde

- Titre du projet
- Nom de l'étudiant, encadrant, établissement
- Année universitaire

## Remerciements

## Résumé / Abstract

- FR + EN
- Mots-clés : IoT, énergie éolienne, Arduino, ESP8266, microservices, PostgreSQL

## Table des matières

## Liste des figures et tableaux

---

## Chapitre 1 — Introduction

1.1 Contexte et problématique  
1.2 Objectifs du projet  
1.3 Méthodologie et planning  
1.4 Structure du rapport  

## Chapitre 2 — État de l'art

2.1 Énergie éolienne à petite échelle  
2.2 Systèmes IoT et edge computing  
2.3 Plateformes de supervision (Blynk, dashboards web)  
2.4 Travaux connexes et positionnement  

## Chapitre 3 — Analyse et spécifications

3.1 Besoins fonctionnels  
3.2 Besoins non fonctionnels (sécurité, disponibilité, latence)  
3.3 Cas d'utilisation (utilisateur, administrateur, dispositif IoT)  
3.4 Architecture globale du système  

## Chapitre 4 — Conception matérielle

4.1 Chaîne de génération mécanique  
4.2 Conditionnement électrique (redresseur, stockage, relais)  
4.3 Capteurs et actionneurs  
4.4 Schéma de câblage et choix des composants  

## Chapitre 5 — Conception logicielle embarquée

5.1 Firmware Arduino UNO (acquisition, alertes, LCD)  
5.2 Pont WiFi ESP8266/ESP32 (Blynk + REST)  
5.3 Protocole série et format des messages  
5.4 Gestion des pannes et calibration  

## Chapitre 6 — Plateforme logicielle multi-niveaux

6.1 Architecture Front Office (Express, Angular, Flutter)  
6.2 Architecture Back Office (Spring Boot, Thymeleaf)  
6.3 Modèle de données partagé (PostgreSQL)  
6.4 API REST et ingestion IoT  
6.5 Sécurité et authentification  

## Chapitre 7 — Implémentation

7.1 Environnement de développement  
7.2 Déploiement des backends  
7.3 Interfaces utilisateur  
7.4 Intégration bout-en-bout  

## Chapitre 8 — Tests et validation

8.1 Tests unitaires et d'intégration  
8.2 Tests matériels (tension, température, relais)  
8.3 Tests de charge et latence réseau  
8.4 Résultats et analyse  

## Chapitre 9 — Conclusion et perspectives

9.1 Bilan du projet  
9.2 Limites  
9.3 Évolutions futures (ESP32 natif, ML, MQTT, cloud)  

## Bibliographie

## Annexes

- A. Schémas électriques  
- B. Captures d'écran (Blynk, Angular, admin)  
- C. Extraits de code  
- D. Guide d'installation (`README.md`)  
