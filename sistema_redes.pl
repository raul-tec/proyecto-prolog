% =================================================================
% SISTEMA EXPERTO PARA EL DIAGNOSTICO DE PROBLEMAS DE RED
% =================================================================

% =================================================================
% 1. BASE DE HECHOS - Conocimiento Declarativo
% =================================================================

tipo_red(inalambrica).
tipo_red(cableada).
tipo_red(mixta).

dispositivo(router).
dispositivo(switch).
dispositivo(access_point).
dispositivo(modem).
dispositivo(tarjeta_red).
dispositivo(cable_ethernet).
dispositivo(adaptador_wifi).
dispositivo(repetidor_wifi).
dispositivo(powerline).
dispositivo(hub).

componente_fisico(cable_ethernet).
componente_fisico(conector_rj45).
componente_fisico(puerto_switch).
componente_fisico(antena_wifi).
componente_fisico(fuente_poder).
componente_fisico(led_estado).
componente_fisico(boton_reset).
componente_fisico(puerto_wan).
componente_fisico(puerto_lan).

protocolo(dhcp).
protocolo(dns).
protocolo(tcp_ip).
protocolo(arp).
protocolo(icmp).
protocolo(http).
protocolo(ftp).

sintoma_wifi(no_detecta_redes).
sintoma_wifi(detecta_red_no_conecta).
sintoma_wifi(conecta_sin_internet).
sintoma_wifi(senal_debil).
sintoma_wifi(desconexiones_frecuentes).
sintoma_wifi(no_obtiene_ip).
sintoma_wifi(autenticacion_falla).
sintoma_wifi(velocidad_muy_lenta).

sintoma_ethernet(luz_enlace_apagada).
sintoma_ethernet(desconecta_al_mover_cable).
sintoma_ethernet(no_funciona_puerto_especifico).
sintoma_ethernet(velocidad_limitada_10mbps).
sintoma_ethernet(cable_no_detectado).

sintoma_general(sin_acceso_internet).
sintoma_general(dns_no_resuelve).
sintoma_general(otros_dispositivos_fallan).
sintoma_general(problema_solo_un_dispositivo).
sintoma_general(ping_falla_gateway).
sintoma_general(navegacion_lenta).
sintoma_general(no_puede_acceder_router).

sintoma_hardware(dispositivo_caliente).
sintoma_hardware(olor_quemado).
sintoma_hardware(reinicio_espontaneo).
sintoma_hardware(luces_led_apagadas).
sintoma_hardware(ruido_ventilador).

estado_ip(ip_duplicada).
estado_ip(ip_fuera_rango).
estado_ip(no_obtiene_ip_dhcp).
estado_ip(gateway_incorrecto).

caracteristica_wifi(canal_congestionado).
caracteristica_wifi(potencia_transmision_baja).
caracteristica_wifi(muchos_dispositivos_conectados).

caracteristica_cable(longitud_mayor_100m).
caracteristica_cable(cable_categoria_inferior).
caracteristica_cable(conector_danado).

% =================================================================
% 2. RELACIONES ESTRUCTURALES Y CAUSALES
% =================================================================

contiene_componente(router, puerto_switch).
contiene_componente(router, antena_wifi).
contiene_componente(router, fuente_poder).
contiene_componente(router, led_estado).
contiene_componente(router, puerto_wan).
contiene_componente(router, puerto_lan).
contiene_componente(switch, puerto_switch).
contiene_componente(switch, fuente_poder).
contiene_componente(switch, led_estado).
contiene_componente(cable_ethernet, conector_rj45).
contiene_componente(access_point, antena_wifi).
contiene_componente(access_point, puerto_lan).

afecta_componente(sintoma_wifi(no_detecta_redes), adaptador_wifi).
afecta_componente(sintoma_wifi(senal_debil), antena_wifi).
afecta_componente(sintoma_ethernet(luz_enlace_apagada), puerto_switch).
afecta_componente(sintoma_ethernet(desconecta_al_mover_cable), cable_ethernet).
afecta_componente(sintoma_hardware(dispositivo_caliente), fuente_poder).
afecta_componente(sintoma_hardware(luces_led_apagadas), led_estado).
afecta_componente(sintoma_ethernet(cable_no_detectado), conector_rj45).
afecta_componente(sintoma_general(no_puede_acceder_router), puerto_wan).

funcion_dispositivo(router, servidor_dhcp).
funcion_dispositivo(router, enrutamiento_gateway).
funcion_dispositivo(router, firewall_basico).
funcion_dispositivo(router, nat_translation).
funcion_dispositivo(modem, conexion_isp).
funcion_dispositivo(adaptador_wifi, cliente_wifi).
funcion_dispositivo(switch, conmutacion_capa2).
funcion_dispositivo(access_point, punto_acceso_wifi).
funcion_dispositivo(repetidor_wifi, amplificacion_senal).

implicacion(sintoma_general(sin_acceso_internet), falla_total).
implicacion(sintoma_general(otros_dispositivos_fallan), falla_centralizada).
implicacion(sintoma_general(problema_solo_un_dispositivo), falla_localizada).
implicacion(sintoma_hardware(olor_quemado), riesgo_critico).
implicacion(sintoma_general(ping_falla_gateway), problema_enrutamiento).
implicacion(sintoma_wifi(autenticacion_falla), problema_seguridad).
implicacion(sintoma_ethernet(velocidad_limitada_10mbps), problema_negociacion).

fuente_interferencia(microondas, '2.4GHz').
fuente_interferencia(telefono_inalambrico_antiguo, '2.4GHz').
fuente_interferencia(paredes_gruesas_hormigon, ambas).
fuente_interferencia(otras_redes_wifi, ambas).
fuente_interferencia(bluetooth, '2.4GHz').
fuente_interferencia(monitor_bebe, '2.4GHz').
fuente_interferencia(camara_seguridad_inalambrica, ambas).

causa_comun(sobrecarga_electrica, fuente_poder).
causa_comun(humedad_excesiva, componente_fisico).
causa_comun(polvo_acumulado, ventilacion).
causa_comun(edad_dispositivo, deterioro_general).

% =================================================================
% 3. BASE DE REGLAS - Conocimiento Procedimental
% =================================================================

% --- Capa 1: Inferencia de Problemas Intermedios ---

problema_inferido(falla_componente(Componente)) :-
    evidencia(Evidencia),
    member(Sintoma, Evidencia),
    afecta_componente(Sintoma, Componente).

problema_inferido(problema_protocolo(dhcp)) :-
    evidencia(Evidencia),
    (member(sintoma_wifi(no_obtiene_ip), Evidencia) ; 
     member(estado_ip(ip_duplicada), Evidencia) ;
     member(estado_ip(no_obtiene_ip_dhcp), Evidencia)).

problema_inferido(problema_protocolo(dns)) :-
    evidencia(Evidencia),
    member(sintoma_general(dns_no_resuelve), Evidencia).

problema_inferido(problema_protocolo(arp)) :-
    evidencia(Evidencia),
    member(estado_ip(ip_duplicada), Evidencia).

problema_inferido(problema_cobertura_wifi) :-
    evidencia(Evidencia),
    (member(sintoma_wifi(senal_debil), Evidencia) ;
     member(caracteristica_wifi(potencia_transmision_baja), Evidencia)).

problema_inferido(problema_interferencia_wifi) :-
    evidencia(Evidencia),
    member(sintoma_wifi(desconexiones_frecuentes), Evidencia),
    member(caracteristica_wifi(canal_congestionado), Evidencia).

problema_inferido(problema_autenticacion_wifi) :-
    evidencia(Evidencia),
    member(sintoma_wifi(autenticacion_falla), Evidencia).

problema_inferido(problema_sobrecarga_red) :-
    evidencia(Evidencia),
    member(caracteristica_wifi(muchos_dispositivos_conectados), Evidencia),
    member(sintoma_wifi(velocidad_muy_lenta), Evidencia).

problema_inferido(problema_negociacion_velocidad) :-
    evidencia(Evidencia),
    member(sintoma_ethernet(velocidad_limitada_10mbps), Evidencia).

problema_inferido(problema_calidad_cable) :-
    evidencia(Evidencia),
    (member(caracteristica_cable(longitud_mayor_100m), Evidencia) ;
     member(caracteristica_cable(cable_categoria_inferior), Evidencia) ;
     member(caracteristica_cable(conector_danado), Evidencia)).

problema_inferido(dispositivo_sospechoso(Dispositivo)) :-
    problema_inferido(falla_componente(Componente)),
    contiene_componente(Dispositivo, Componente).

problema_inferido(dispositivo_sospechoso(Dispositivo)) :-
    problema_inferido(problema_protocolo(Protocolo)),
    funcion_dispositivo(Dispositivo, FuncProto),
    sub_atom(FuncProto, _, _, _, Protocolo).

problema_inferido(dispositivo_sospechoso(Dispositivo)) :-
    evidencia(Evidencia),
    member(Sintoma, Evidencia),
    implicacion(Sintoma, falla_centralizada),
    (Dispositivo = router ; Dispositivo = modem).

problema_inferido(falla_isp_externa) :-
    evidencia(Evidencia),
    member(sintoma_general(otros_dispositivos_fallan), Evidencia),
    member(sintoma_general(ping_falla_gateway), Evidencia).

% --- Capa 2: Reglas de Diagnostico Final ---

diagnostico(revisar_dispositivo(Dispositivo), Justificacion) :-
    problema_inferido(dispositivo_sospechoso(Dispositivo)),
    format(string(Justificacion), 'Se sospecha del ~w porque sus funciones o componentes estan implicados por los sintomas.', [Dispositivo]).

diagnostico(reemplazar_cable_ethernet, 'Falla fisica del cable Ethernet inferida por sintomas de desconexion al moverlo.') :-
    problema_inferido(falla_componente(cable_ethernet)).

diagnostico(mejorar_calidad_cable, 'Problemas de calidad en el cableado detectados. Verificar longitud, categoria y conectores.') :-
    problema_inferido(problema_calidad_cable).

diagnostico(reemplazar_hardware_critico(Componente), 'Falla critica de hardware inferida por sintomas de sobrecalentamiento u olor a quemado.') :-
    problema_inferido(falla_componente(fuente_poder)).

diagnostico(configurar_servidores_dns, 'La resolucion de nombres de dominio (DNS) esta fallando. Se debe verificar la configuracion DNS.') :-
    problema_inferido(problema_protocolo(dns)).

diagnostico(resolver_conflicto_ip, 'Conflicto de IP detectado. El servidor DHCP puede estar mal configurado o hay IPs estaticas duplicadas.') :-
    problema_inferido(problema_protocolo(dhcp)),
    evidencia(E), member(estado_ip(ip_duplicada), E).

diagnostico(verificar_configuracion_dhcp, 'Problema con la asignacion automatica de direcciones IP. Verificar servidor DHCP.') :-
    problema_inferido(problema_protocolo(dhcp)),
    evidencia(E), member(estado_ip(no_obtiene_ip_dhcp), E).

diagnostico(verificar_credenciales_wifi, 'Error de autenticacion WiFi. Verificar contraseña y tipo de seguridad.') :-
    problema_inferido(problema_autenticacion_wifi).

diagnostico(optimizar_red_wifi, 'Sobrecarga en la red WiFi detectada. Reducir dispositivos conectados o mejorar ancho de banda.') :-
    problema_inferido(problema_sobrecarga_red).

diagnostico(ajustar_negociacion_velocidad, 'Problema de negociacion de velocidad. Configurar manualmente la velocidad del puerto.') :-
    problema_inferido(problema_negociacion_velocidad).

diagnostico(mejorar_cobertura_wifi, 'La señal es debil, lo que indica un problema de alcance o barreras fisicas.') :-
    problema_inferido(problema_cobertura_wifi).

diagnostico(resolver_interferencia_wifi, Justificacion) :-
    problema_inferido(problema_interferencia_wifi),
    findall(Fuente, fuente_interferencia(Fuente, _), Fuentes),
    format(string(Justificacion), 'Interferencia detectada. Alejar posibles fuentes como: ~w.', [Fuentes]).

diagnostico(contactar_proveedor_internet, 'El problema afecta a todos los dispositivos y no parece originarse en el router, apuntando a una falla externa del ISP.') :-
    problema_inferido(falla_isp_externa).

diagnostico(revisar_tabla_arp, 'Conflicto en la tabla ARP detectado. Limpiar cache ARP de los dispositivos.') :-
    problema_inferido(problema_protocolo(arp)).

% =================================================================
% 4. BASE DE SOLUCIONES Y PRIORIDADES
% =================================================================

solucion_detallada(revisar_dispositivo(router), 'Inspeccionar el router: verificar luces LED, reiniciar, y acceder a su configuracion para revisar el estado del DHCP y la conexion WAN.').
solucion_detallada(revisar_dispositivo(switch), 'Inspeccionar el switch: verificar luces de los puertos, probar con diferentes puertos, reiniciar el dispositivo.').
solucion_detallada(revisar_dispositivo(modem), 'Inspeccionar el modem: verificar luces de estado, reiniciar, comprobar conexiones coaxiales o DSL.').
solucion_detallada(reemplazar_cable_ethernet, 'Reemplazar el cable Ethernet por uno de Categoria 5e o superior.').
solucion_detallada(mejorar_calidad_cable, 'Verificar que el cable sea menor a 100m, categoria adecuada (Cat5e/Cat6) y conectores en buen estado.').
solucion_detallada(reemplazar_hardware_critico(_), 'PELIGRO: Apagar y desconectar el equipo inmediatamente. Reemplazar el dispositivo afectado.').
solucion_detallada(configurar_servidores_dns, 'Configurar servidores DNS publicos (ej: 8.8.8.8, 1.1.1.1) en el dispositivo o en el router.').
solucion_detallada(resolver_conflicto_ip, 'Asegurarse que los dispositivos obtengan IP por DHCP o asignar IPs estaticas unicas y fuera del rango DHCP.').
solucion_detallada(verificar_configuracion_dhcp, 'Acceder al router y verificar que el servidor DHCP este habilitado con rango de IPs adecuado.').
solucion_detallada(verificar_credenciales_wifi, 'Verificar que la contraseña WiFi sea correcta y que el tipo de seguridad coincida (WPA2/WPA3).').
solucion_detallada(optimizar_red_wifi, 'Desconectar dispositivos innecesarios, actualizar firmware del router, o considerar un upgrade de ancho de banda.').
solucion_detallada(ajustar_negociacion_velocidad, 'Configurar manualmente la velocidad y duplex del puerto de red en vez de usar auto-negociacion.').
solucion_detallada(mejorar_cobertura_wifi, 'Reubicar el router a una posicion central y elevada. Considerar usar repetidores o un sistema Mesh.').
solucion_detallada(resolver_interferencia_wifi, 'Cambiar el canal del WiFi a uno menos congestionado (1, 6, u 11 para 2.4GHz) y alejar el router de otros aparatos electronicos.').
solucion_detallada(contactar_proveedor_internet, 'Contactar al soporte tecnico del proveedor de internet para reportar una caida del servicio en la zona.').
solucion_detallada(revisar_tabla_arp, 'Ejecutar "arp -d *" en Windows o "sudo arp -d -a" en Linux/Mac para limpiar la tabla ARP.').

prioridad_diagnostico(reemplazar_hardware_critico(_), critica).
prioridad_diagnostico(resolver_conflicto_ip, alta).
prioridad_diagnostico(revisar_dispositivo(router), alta).
prioridad_diagnostico(verificar_configuracion_dhcp, alta).
prioridad_diagnostico(verificar_credenciales_wifi, alta).
prioridad_diagnostico(contactar_proveedor_internet, media).
prioridad_diagnostico(mejorar_calidad_cable, media).
prioridad_diagnostico(ajustar_negociacion_velocidad, media).
prioridad_diagnostico(optimizar_red_wifi, media).
prioridad_diagnostico(mejorar_cobertura_wifi, baja).
prioridad_diagnostico(resolver_interferencia_wifi, baja).
prioridad_diagnostico(revisar_tabla_arp, baja).

% =================================================================
% 5. REGLAS DE PREVENCION Y MANTENIMIENTO
% =================================================================

recomendacion_prevencion(mantenimiento_regular, 'Limpiar dispositivos de polvo cada 6 meses y verificar conexiones.').
recomendacion_prevencion(monitoreo_temperatura, 'Verificar que los dispositivos no se sobrecalienten, especialmente en verano.').
recomendacion_prevencion(actualizacion_firmware, 'Mantener firmware actualizado en router y dispositivos de red.').
recomendacion_prevencion(respaldo_configuracion, 'Guardar una copia de la configuracion del router antes de hacer cambios.').
recomendacion_prevencion(revision_cables, 'Inspeccionar cables periodicamente en busca de daños fisicos.').

% =================================================================
% 6. MOTOR DE INFERENCIA Y EXPLICACION
% =================================================================

limpiar_memoria :-
    retractall(evidencia(_)),
    retractall(hallazgo_registrado(_, _)).

analizar_problema(Evidencia, Resultados) :-
    limpiar_memoria,
    asserta(evidencia(Evidencia)),
    findall(
        diagnostico_completo(Diagnostico, Prioridad, Justificacion, Solucion),
        (
            diagnostico(Diagnostico, Justificacion),
            (prioridad_diagnostico(Diagnostico, P) -> Prioridad = P ; Prioridad = media),
            solucion_detallada(Diagnostico, Solucion)
        ),
        ResultadosBrutos
    ),
    sort(ResultadosBrutos, Resultados),
    limpiar_memoria.

explicar_razonamiento(Evidencia) :-
    limpiar_memoria,
    asserta(evidencia(Evidencia)),
    writeln('=== INICIO DEL ANALISIS DE RAZONAMIENTO ==='),
    nl,
    writeln('1. Evidencia Proporcionada:'),
    forall(member(E, Evidencia), writeln(E)),
    nl,
    writeln('2. Hallazgos Intermedios Derivados:'),
    forall(
        (problema_inferido(H), \+ hallazgo_registrado(H, _)),
        (
            assertz(hallazgo_registrado(H, 'derivado')),
            format('  [+] Se deriva el hallazgo: ~w~n', [H])
        )
    ),
    nl,
    writeln('3. Diagnosticos y Conclusiones:'),
    forall(
        diagnostico(D, J),
        (
            format('  [*] Diagnostico Propuesto: ~w~n', [D]),
            format('      Justificacion: ~s~n', [J]),
            (solucion_detallada(D, S) -> format('      Solucion Sugerida: ~s~n', [S]) ; true),
            nl
        )
    ),
    writeln('4. Recomendaciones de Prevencion:'),
    forall(
        recomendacion_prevencion(R, D),
        format('  [!] ~w: ~s~n', [R, D])
    ),
    writeln('=== FIN DEL ANALISIS ==='),
    limpiar_memoria.

% Predicado auxiliar para obtener recomendaciones de prevencion
obtener_recomendaciones_prevencion(Recomendaciones) :-
    findall(
        recomendacion(Tipo, Descripcion),
        recomendacion_prevencion(Tipo, Descripcion),
        Recomendaciones
    ).

% =================================================================
% EJEMPLO 1: PROBLEMA DE CABLE ETHERNET DANADO
% =================================================================
% Sintomas: El cable se desconecta al moverlo y la luz de enlace esta apagada
% 
% ?- analizar_problema([sintoma_ethernet(desconecta_al_mover_cable), 
%                      sintoma_ethernet(luz_enlace_apagada)], Resultados).

% =================================================================
% EJEMPLO 2: PROBLEMA DE WiFi CON INTERFERENCIA
% =================================================================
% Sintomas: Desconexiones frecuentes y canal congestionado
%
% ?- analizar_problema([sintoma_wifi(desconexiones_frecuentes), 
%                      caracteristica_wifi(canal_congestionado)], Resultados).

% =================================================================
% EJEMPLO 3: PROBLEMA CRITICO DE HARDWARE
% =================================================================
% Sintomas: Dispositivo caliente con olor a quemado
%
% ?- analizar_problema([sintoma_hardware(dispositivo_caliente), 
%                      sintoma_hardware(olor_quemado)], Resultados).

% =================================================================
% EJEMPLO 4: PROBLEMA DE CONFIGURACION DHCP
% =================================================================
% Sintomas: No obtiene IP y hay IPs duplicadas en la red
%
% ?- analizar_problema([sintoma_wifi(no_obtiene_ip), 
%                      estado_ip(ip_duplicada)], Resultados).

% =================================================================
% EJEMPLO 5: PROBLEMA DE AUTENTICACION WiFi
% =================================================================
% Sintomas: Falla la autenticacion WiFi
%
% ?- analizar_problema([sintoma_wifi(autenticacion_falla)], Resultados).

% =================================================================
% EJEMPLO 6: PROBLEMA COMPLEJO - FALLA TOTAL DE INTERNET
% =================================================================
% Sintomas: Sin acceso a internet, otros dispositivos fallan, ping al gateway falla
%
% ?- analizar_problema([sintoma_general(sin_acceso_internet),
%                      sintoma_general(otros_dispositivos_fallan),
%                      sintoma_general(ping_falla_gateway)], Resultados).

% =================================================================
% EJEMPLO 7: PROBLEMA DE VELOCIDAD ETHERNET
% =================================================================
% Sintomas: Velocidad limitada a 10Mbps en conexion Ethernet
%
% ?- analizar_problema([sintoma_ethernet(velocidad_limitada_10mbps)], Resultados).

% =================================================================
% EJEMPLO 8: PROBLEMA DE SOBRECARGA WiFi
% =================================================================
% Sintomas: Muchos dispositivos conectados y velocidad muy lenta
%
% ?- analizar_problema([caracteristica_wifi(muchos_dispositivos_conectados),
%                      sintoma_wifi(velocidad_muy_lenta)], Resultados).

% =================================================================
% EJEMPLO 9: PROBLEMA DE DNS
% =================================================================
% Sintomas: DNS no resuelve nombres de dominio
%
% ?- analizar_problema([sintoma_general(dns_no_resuelve)], Resultados).

% =================================================================
% EJEMPLO 10: PROBLEMA DE CALIDAD DE CABLE
% =================================================================
% Sintomas: Cable de categoria inferior y longitud mayor a 100m
%
% ?- analizar_problema([caracteristica_cable(cable_categoria_inferior),
%                      caracteristica_cable(longitud_mayor_100m)], Resultados).
