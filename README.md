# Mi Feria Inteligente - App Smart TV

App Flutter para la pantalla pública del recinto (Android TV / Google TV),
basada en el documento de diseño de interfaces "Mi Feria Inteligente".

## Pantallas
- T-01 Vinculación y Configuración (`/`)
- T-02 Bienvenida y Espera (`/bienvenida`)
- T-03 Agenda en Tiempo Real (`/agenda`)
- T-04 Transmisión en Vivo (`/transmision`)
- T-05 Resultados de Votaciones (`/resultados`)
- T-06 Alerta de Emergencia (`/alerta`)

## Correr
```
flutter pub get
flutter run -d <id-del-dispositivo-tv>
```

Todas las transiciones entre pantallas están simuladas con botones/timers
(en producción vendrían del backend vía WebSocket, como indica el documento).
