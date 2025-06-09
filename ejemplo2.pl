% SISTEMA EXPERTO PARA EL DIAGNÓSTICO DE HARDWARE DE RED

% MOTOR DE INFERENCIA

% https://www.fonerbooks.com/network.htm

% Predicado principal para iniciar el sistema experto
diagnosticar :-
    texto(inicio, Titulo),
    nl, write('===================================================='), nl,
    write(Titulo), nl,
    write('===================================================='), nl,
    nl, write('Responde a las siguientes preguntas con "si" o "no".'), nl, nl,
    diagnosticar_desde(es_red_cableada). % El diagnóstico comienza en la primera pregunta real

% Caso base de la recursión: hemos llegado a una conclusión/diagnóstico de red.
diagnosticar_desde(Nodo) :-
    conclusion(Nodo),
    !,
    texto(Nodo, Diagnostico),
    nl, write('--- DIAGNÓSTICO DE RED ---'), nl,
    format('~n[Solución] ~w~n', [Diagnostico]),
    nl, write('-------------------------'), nl.

% Caso recursivo: estamos en un nodo de pregunta.
diagnosticar_desde(Nodo) :-
    texto(Nodo, Pregunta),
    preguntar(Pregunta, Respuesta),
    regla(Nodo, Respuesta, SiguienteNodo),
    diagnosticar_desde(SiguienteNodo).

% Predicado para manejar la interacción con el usuario
preguntar(Pregunta, Respuesta) :-
    format('~n[Pregunta] ~w (si/no)?~n> ', [Pregunta]),
    read_line_to_string(user_input, Entrada),
    string_lower(Entrada, EntradaMinusculas),
    ( (EntradaMinusculas == "si" ; EntradaMinusculas == "s") -> Respuesta = 'Sí'
    ; (EntradaMinusculas == "no" ; EntradaMinusculas == "n") -> Respuesta = 'No'
    ; write('Por favor, responde solo "si" o "no".'), nl, preguntar(Pregunta, Respuesta)
    ).

% BASE DE CONOCIMIENTO

% --- Hechos: Definición de los hechos basados en preguntas ---

% Título inicial
texto(inicio, 'Inicio del Diagnóstico de Red Local').

% Preguntas
texto(es_red_cableada, '¿El problema es en una red cableada?').
texto(pc_ve_red_inalambrica, '¿La PC detecta la red inalámbrica?').
texto(funciona_sin_seguridad, '¿Funciona si la red no tiene seguridad (abierta)?').
texto(funciona_con_cable, '¿Funciona si conectas la PC directamente al router con un cable?').
texto(problema_filtro_mac_firewall, '¿El problema podría ser el filtrado de direcciones MAC o el firewall del router?').
texto(modifico_config_defecto, '¿Has modificado la configuración por defecto del router?').
texto(pierde_senal, '¿La señal se pierde o la conexión es lenta?').
texto(mismo_estandar_wifi, '¿El PC y el router usan el mismo estándar WiFi?').
texto(otros_dispositivos_wifi_funcionan, '¿Otros dispositivos WiFi funcionan correctamente en la misma red?').
texto(problemas_aleatorios, '¿Los problemas son aleatorios e intermitentes?').
texto(nuevo_hub_switch, '¿Se ha añadido un nuevo hub/switch a la red recientemente?').
texto(luz_enlace_encendida, '¿La luz de enlace (link) del puerto de red está encendida?').
texto(configuracion_copiada, '¿Se copió la configuración de red de otra estación de trabajo?').
texto(problema_admin_dispositivos, '¿Hay algún problema en el Administrador de Dispositivos (ej. conflictos, driver faltante)?').
texto(problema_al_mover_cable, '¿El problema ocurre al mover o tocar el cable de red?').
texto(cable_dentro_limites, '¿La longitud del cable está dentro de los límites físicos (usualmente 100m)?').
texto(probo_otro_puerto, '¿Has probado un puerto diferente en el hub/switch?').
texto(falla_con_mucho_trafico, '¿La conexión falla cuando hay mucho tráfico en la red o muchos usuarios conectados?').
texto(pc_inestable_offline, '¿El PC también funciona de forma inestable fuera de la red (offline)?').
texto(soluciona_con_cable_corto, '¿Se soluciona el problema conectando la PC directamente al hub/switch con un cable corto de prueba?').
texto(funciona_con_tarjeta_nueva, '¿Funciona una nueva tarjeta de red en la PC?').

% Conclusiones (Nodos terminales)
texto(verificar_wifi, 'Verifica que el WiFi esté habilitado, el router activo, que estés dentro del alcance y que la red no esté oculta.').
texto(contrasena_incorrecta, 'La contraseña o el protocolo de seguridad (WPA/WPA2) son incorrectos.').
texto(agregar_mac, 'Agrega la dirección MAC a la lista de dispositivos permitidos y modifica la configuración del firewall.').
texto(verificar_router_activo, 'Comprueba que la red o Internet funcionen en el router inalámbrico (usa otro dispositivo).').
texto(restaurar_defecto, 'Restaura la configuración de fábrica. Si la conexión por cable no funciona, el WiFi tampoco lo hará.').
texto(interferencia, 'Problema de interferencia, mala ubicación de la PC o del router, adaptador WiFi defectuoso o fuera de rango.').
texto(actualizar_hardware, 'Actualiza todo el hardware de red al estándar más reciente.').
texto(fallo_router, 'Fallo del router, del puente de red o de la conexión a Internet.').
texto(actualizar_driver_wifi, 'Intenta actualizar el driver de tu adaptador WiFi.').
texto(revisar_cable_crossover, 'Revisa el cableado del puerto de enlace/crossover.').
texto(revisar_capa_fisica, 'Revisa la capa física: cables en buen estado, conectores bien puestos, dispositivos encendidos.').
texto(clonar_configuracion, 'Clona la configuración desde una estación de trabajo que funcione correctamente.').
texto(actualizar_driver_nic, 'Actualiza el driver, reemplaza la tarjeta de red.').
texto(probar_conector_rj45, 'Flexiona el cable en la parte trasera de la PC y observa el LED de enlace para probar el conector RJ-45.').
texto(agregar_repetidores, 'Agrega repetidores o switches para ampliar la señal, o redirige los cables por una ruta más corta.').
texto(fallo_puerto_anterior, 'Si la conexión es estable en el nuevo puerto, el puerto anterior está fallando.').
texto(reemplazar_hub_por_switch, 'Reemplaza el hub por un switch. Revisa la utilización de recursos del servidor.').
texto(problema_no_es_red, 'El problema no es de red. Procede al diagrama de "Rendimiento de la Placa Base".').
texto(cableado_defectuoso, 'Cableado defectuoso en el patch panel o en la pared.').
texto(desechar_adaptador_antiguo, 'Desecha el adaptador antiguo.').
texto(conflicto_software, 'Causa más probable: conflictos de software, mala configuración del sistema operativo o un virus.').


% --- Hechos: Definición de Nodos ---
% Se usa para que el motor de inferencia sepa cuándo detenerse.

conclusion(verificar_wifi).
conclusion(contrasena_incorrecta).
conclusion(agregar_mac).
conclusion(verificar_router_activo).
conclusion(restaurar_defecto).
conclusion(interferencia).
conclusion(actualizar_hardware).
conclusion(fallo_router).
conclusion(actualizar_driver_wifi).
conclusion(revisar_cable_crossover).
conclusion(revisar_capa_fisica).
conclusion(clonar_configuracion).
conclusion(actualizar_driver_nic).
conclusion(probar_conector_rj45).
conclusion(agregar_repetidores).
conclusion(fallo_puerto_anterior).
conclusion(reemplazar_hub_por_switch).
conclusion(problema_no_es_red).
conclusion(cableado_defectuoso).
conclusion(desechar_adaptador_antiguo).
conclusion(conflicto_software).


% --- Reglas: Lógica de Decisión (Transiciones del Diagrama) ---

% --- Rama Izquierda: RED INALÁMBRICA (WIFI) ---
regla(es_red_cableada, 'No', pc_ve_red_inalambrica).
regla(pc_ve_red_inalambrica, 'No', verificar_wifi).
regla(pc_ve_red_inalambrica, 'Sí', funciona_sin_seguridad).
regla(funciona_sin_seguridad, 'Sí', contrasena_incorrecta).
regla(funciona_sin_seguridad, 'No', funciona_con_cable).
regla(funciona_con_cable, 'Sí', problema_filtro_mac_firewall).
regla(funciona_con_cable, 'No', modifico_config_defecto).
regla(problema_filtro_mac_firewall, 'Sí', agregar_mac).
regla(problema_filtro_mac_firewall, 'No', verificar_router_activo).
regla(modifico_config_defecto, 'No', restaurar_defecto).
regla(modifico_config_defecto, 'Sí', pierde_senal).
regla(pierde_senal, 'Sí', mismo_estandar_wifi).
regla(pierde_senal, 'No', otros_dispositivos_wifi_funcionan).
regla(mismo_estandar_wifi, 'Sí', interferencia).
regla(mismo_estandar_wifi, 'No', actualizar_hardware).
regla(otros_dispositivos_wifi_funcionan, 'No', fallo_router).
regla(otros_dispositivos_wifi_funcionan, 'Sí', actualizar_driver_wifi).

% --- Rama Derecha: RED CABLEADA (LAN) ---
regla(es_red_cableada, 'Sí', problemas_aleatorios).
regla(problemas_aleatorios, 'No', nuevo_hub_switch).
regla(problemas_aleatorios, 'Sí', problema_al_mover_cable).
regla(nuevo_hub_switch, 'Sí', revisar_cable_crossover).
regla(nuevo_hub_switch, 'No', luz_enlace_encendida).
regla(luz_enlace_encendida, 'No', revisar_capa_fisica).
regla(luz_enlace_encendida, 'Sí', configuracion_copiada).
regla(configuracion_copiada, 'No', clonar_configuracion).
regla(configuracion_copiada, 'Sí', problema_admin_dispositivos).
regla(problema_admin_dispositivos, 'No', probo_otro_puerto).
regla(problema_admin_dispositivos, 'Sí', actualizar_driver_nic).
regla(problema_al_mover_cable, 'Sí', probar_conector_rj45).
regla(problema_al_mover_cable, 'No', cable_dentro_limites).
regla(cable_dentro_limites, 'No', agregar_repetidores).
regla(cable_dentro_limites, 'Sí', probo_otro_puerto).
regla(probo_otro_puerto, 'No', falla_con_mucho_trafico).
regla(probo_otro_puerto, 'Sí', fallo_puerto_anterior).
regla(falla_con_mucho_trafico, 'Sí', reemplazar_hub_por_switch).
regla(falla_con_mucho_trafico, 'No', pc_inestable_offline).
regla(pc_inestable_offline, 'Sí', problema_no_es_red).
regla(pc_inestable_offline, 'No', soluciona_con_cable_corto).
regla(soluciona_con_cable_corto, 'Sí', cableado_defectuoso).
regla(soluciona_con_cable_corto, 'No', funciona_con_tarjeta_nueva).
regla(funciona_con_tarjeta_nueva, 'Sí', desechar_adaptador_antiguo).
regla(funciona_con_tarjeta_nueva, 'No', conflicto_software).