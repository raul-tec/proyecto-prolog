% =================================================================
% SISTEMA EXPERTO PARA EL DIAGNÓSTICO DE PROBLEMAS DE RED
% =================================================================
%
% Autor: Sistema Experto Restructurado y Completado por IA
% Descripción: Sistema experto basado en reglas de producción con
%              encadenamiento hacia adelante (forward-chaining) para
%              diagnosticar problemas de red.
%
% ESTRUCTURA DEL SISTEMA EXPERTO:
% 1. BASE DE HECHOS (Facts)      - El conocimiento declarativo.
% 2. BASE DE REGLAS (Rules)      - El conocimiento procedimental.
% 3. MOTOR DE INFERENCIA (Engine) - La parte que razona.
% 4. INTERFAZ DE USUARIO (UI)    - La capa de interacción.
% =================================================================

% =================================================================
% 1. BASE DE HECHOS (FACTS) - Conocimiento Declarativo
% =================================================================
% Define las entidades del dominio: síntomas y soluciones.

% --- HECHOS: Afirmamos que estos pueden ser los síntomas observables ---
problema_red(es_red_inalambrica, 'El problema es en una red inalámbrica (WiFi)').
problema_red(es_red_cableada, 'El problema es en una red cableada (Ethernet)').
problema_red(pc_no_detecta_red_wifi, 'La PC no detecta ninguna red inalámbrica').
problema_red(pc_si_detecta_red_wifi, 'La PC sí detecta la red inalámbrica, pero no conecta').
problema_red(conexion_funciona_con_seguridad_desactivada, 'La conexión WiFi funciona solo si se desactiva la seguridad').
problema_red(conexion_no_funciona_aun_sin_seguridad, 'La conexión WiFi no funciona ni siquiera con la seguridad desactivada').
problema_red(conexion_con_cable_directo_al_router_funciona, 'La conexión a internet funciona si se conecta la PC por cable al router').
problema_red(conexion_con_cable_directo_al_router_no_funciona, 'La conexión a internet tampoco funciona conectando la PC por cable al router').
problema_red(sospecha_filtro_mac_o_firewall, 'Se sospecha que el problema es el filtrado MAC o el firewall del router').
problema_red(no_sospecha_filtro_mac_o_firewall, 'No se cree que el problema sea el filtrado MAC o el firewall').
problema_red(configuracion_router_modificada, 'La configuración por defecto del router ha sido modificada').
problema_red(configuracion_router_por_defecto, 'La configuración del router es la de fábrica').
problema_red(senal_wifi_se_pierde_o_es_lenta, 'La señal WiFi se pierde o la conexión es inusualmente lenta').
problema_red(conexion_wifi_estable_pero_sin_acceso, 'La conexión WiFi es estable, pero no hay acceso a la red/internet').
problema_red(pc_y_router_usan_mismo_estandar_wifi, 'El PC y el router usan el mismo estándar WiFi').
problema_red(pc_y_router_usan_diferente_estandar_wifi, 'El PC y el router usan estándares WiFi diferentes o antiguos').
problema_red(otros_dispositivos_wifi_no_funcionan, 'Otros dispositivos WiFi tampoco funcionan en la misma red').
problema_red(otros_dispositivos_wifi_si_funcionan, 'Otros dispositivos WiFi sí funcionan correctamente en la red').
problema_red(conexion_falla_de_forma_estable, 'La conexión falla de manera constante, no es intermitente').
problema_red(conexion_intermitente_o_aleatoria, 'Los problemas de conexión son aleatorios e intermitentes').
problema_red(se_instalo_hub_o_switch_nuevo, 'Se ha añadido un nuevo hub/switch a la red recientemente').
problema_red(no_se_instalo_hardware_nuevo, 'No se ha añadido un nuevo hub/switch recientemente').
problema_red(luz_de_enlace_nic_apagada, 'La luz de enlace del puerto de red en la PC está apagada').
problema_red(luz_de_enlace_nic_encendida, 'La luz de enlace del puerto de red en la PC está encendida').
problema_red(configuracion_ip_copiada_de_otra_pc, 'La configuración de red fue copiada de otra estación de trabajo').
problema_red(configuracion_ip_es_unica_o_automatica, 'La configuración de red es única o se obtiene automáticamente').
problema_red(hay_error_en_administrador_dispositivos, 'Hay un problema visible en el Administrador de Dispositivos').
problema_red(no_hay_error_en_administrador_dispositivos, 'El Administrador de Dispositivos no muestra errores para la tarjeta de red').
problema_red(problema_ocurre_al_mover_cable_de_red, 'El problema ocurre o desaparece al mover o tocar el cable de red').
problema_red(problema_no_depende_de_mover_cable, 'El problema no está relacionado con mover físicamente el cable').
problema_red(longitud_cable_supera_limite, 'La longitud del cable de red es muy larga (cercana o superior a 100m)').
problema_red(longitud_cable_dentro_limite, 'La longitud del cable de red está dentro de los límites recomendados').
problema_red(no_se_probo_otro_puerto_switch, 'No se ha probado a conectar el cable en un puerto diferente del hub/switch').
problema_red(se_probo_otro_puerto_y_funciona, 'Se ha probado un puerto diferente en el hub/switch y la conexión ahora es estable').
problema_red(conexion_falla_con_alto_trafico, 'La conexión falla principalmente cuando hay mucho tráfico en la red').
problema_red(conexion_falla_independiente_del_trafico, 'El fallo de conexión no parece depender del nivel de tráfico de la red').
problema_red(pc_tambien_es_inestable_sin_red, 'El PC funciona de forma inestable incluso cuando está desconectado de la red').
problema_red(pc_es_estable_sin_red, 'El PC funciona de forma estable cuando está desconectado de la red').
problema_red(problema_se_soluciona_con_cable_corto, 'El problema se soluciona conectando la PC al hub/switch con un cable corto de prueba').
problema_red(problema_persiste_con_cable_corto, 'El problema persiste incluso usando un cable corto de prueba').
problema_red(funciona_con_tarjeta_de_red_nueva, 'Se instaló una nueva tarjeta de red en la PC y el problema se solucionó').
problema_red(problema_persiste_con_tarjeta_de_red_nueva, 'Incluso con una tarjeta de red nueva, el problema continúa').

% --- HECHOS: Afirmamos que están las soluciones conocidas ---
solucion(verificar_wifi_basico, 'Verifica que el WiFi del PC esté habilitado, que el router esté encendido y emitiendo, que estés dentro del alcance y que el nombre de la red (SSID) no esté oculto.').
solucion(contrasena_o_protocolo_incorrecto, 'La contraseña (clave de red) es incorrecta o el protocolo de seguridad (WPA2/WPA3) no coincide entre el PC y el router. Verifícalos.').
solucion(agregar_mac_o_revisar_firewall, 'El router puede estar usando un filtro de direcciones MAC o un firewall que bloquea tu dispositivo. Agrega la dirección MAC de tu PC a la lista de permitidos y revisa las reglas del firewall.').
solucion(verificar_internet_en_router, 'El problema parece estar en el router o en la conexión a Internet. Comprueba si otros dispositivos pueden acceder a Internet. Reinicia el router.').
solucion(restaurar_router_a_fabrica, 'Dado que la conexión por cable tampoco funciona y se modificó la configuración, es probable que haya una mala configuración crítica. Restaura el router a su configuración de fábrica.').
solucion(problema_de_interferencia, 'Causa probable: interferencia de otros dispositivos, mala ubicación de la PC o del router, o un adaptador WiFi defectuoso. Intenta cambiar de canal WiFi o reubicar los equipos.').
solucion(actualizar_hardware_wifi, 'Los estándares WiFi incompatibles o muy antiguos pueden causar problemas. Considera actualizar el adaptador WiFi del PC o el router a un estándar más moderno y compatible.').
solucion(fallo_general_router_o_internet, 'Si ningún dispositivo WiFi funciona, es probable que el router haya fallado, el punto de acceso esté mal configurado o haya una caída general del servicio de Internet. Contacta a tu proveedor.').
solucion(actualizar_driver_wifi, 'Si otros dispositivos funcionan bien, el problema probablemente está en tu PC. Intenta actualizar el controlador (driver) de tu adaptador WiFi a la última versión disponible.').
solucion(revisar_cable_crossover_uplink, 'Si se añadió un hub/switch nuevo, verifica que los puertos de enlace (uplink) estén conectados correctamente. Podrías necesitar un cable cruzado (crossover) o un puerto específico si los dispositivos son antiguos.').
solucion(revisar_capa_fisica, 'La luz de enlace apagada indica un problema físico. Revisa que los cables de red estén bien conectados en ambos extremos, que no estén dañados y que tanto la PC como el switch/router estén encendidos.').
solucion(clonar_configuracion_ip, 'Si la configuración IP es única, pero no funciona, intenta clonar la configuración de red desde una estación de trabajo que sí funcione. Podría haber un problema con el servidor DHCP.').
solucion(reinstalar_driver_o_reemplazar_nic, 'Un error en el Administrador de Dispositivos apunta a un problema de software o hardware con la tarjeta de red. Reinstala los drivers. Si no funciona, la tarjeta podría estar defectuosa y necesitar reemplazo.').
solucion(revisar_conector_o_cable, 'Si el problema aparece al mover el cable, el conector RJ-45 o el propio cable están dañados o mal crimpados. Observa el LED de enlace mientras flexionas el cable para confirmar. Reemplaza el cable de red.').
solucion(agregar_repetidores_o_acortar_ruta, 'Un cable demasiado largo degrada la señal. Agrega repetidores o switches para ampliar la red, o redirige el cableado por una ruta más corta.').
solucion(puerto_del_switch_danado, 'Si la conexión es estable en un nuevo puerto, el puerto anterior del hub/switch está dañado. Márcalo como defectuoso y no lo uses.').
solucion(reemplazar_hub_o_revisar_servidor, 'Un hub puede colapsar con mucho tráfico. Reemplaza los hubs por switches. Si ya usas switches, revisa la utilización de recursos del servidor o del router, que podría estar sobrecargado.').
solucion(problema_no_es_de_red, 'Si el PC es inestable incluso sin conexión, el problema no es de la red. El fallo está en el hardware o en el sistema operativo del equipo.').
solucion(cableado_de_pared_defectuoso, 'Si un cable corto funciona pero el cableado de la pared no, entonces el problema está en el cableado estructural (dentro de la pared, en el patch panel o en la roseta de red).').
solucion(tarjeta_de_red_antigua_defectuosa, 'Si una tarjeta de red nueva funciona perfectamente, la tarjeta de red original estaba defectuosa o era incompatible. Deséchala.').
solucion(conflicto_software_o_virus, 'Si todo el hardware parece funcionar, la causa más probable es un conflicto de software, una mala configuración del sistema operativo o un virus que interfiere con la conexión.').


% =================================================================
% 2. BASE DE REGLAS (RULES) - Conocimiento Procedimental
% =================================================================
% Formato: regla(Lista_De_Premisas, Conclusion).
% Si es que se cumplen todas las premisas, entonces la conclusión es válida.

% --- REGLAS PARA PROBLEMAS DE WiFi ---
regla([es_red_inalambrica, pc_no_detecta_red_wifi], verificar_wifi_basico).
regla([es_red_inalambrica, pc_si_detecta_red_wifi, conexion_funciona_con_seguridad_desactivada], contrasena_o_protocolo_incorrecto).
regla([es_red_inalambrica, pc_si_detecta_red_wifi, conexion_no_funciona_aun_sin_seguridad, conexion_con_cable_directo_al_router_funciona, sospecha_filtro_mac_o_firewall], agregar_mac_o_revisar_firewall).
regla([es_red_inalambrica, pc_si_detecta_red_wifi, conexion_no_funciona_aun_sin_seguridad, conexion_con_cable_directo_al_router_funciona, no_sospecha_filtro_mac_o_firewall], verificar_internet_en_router).
regla([es_red_inalambrica, pc_si_detecta_red_wifi, conexion_no_funciona_aun_sin_seguridad, conexion_con_cable_directo_al_router_no_funciona, configuracion_router_por_defecto], restaurar_router_a_fabrica).
regla([es_red_inalambrica, pc_si_detecta_red_wifi, conexion_no_funciona_aun_sin_seguridad, conexion_con_cable_directo_al_router_no_funciona, configuracion_router_modificada, senal_wifi_se_pierde_o_es_lenta, pc_y_router_usan_mismo_estandar_wifi], problema_de_interferencia).
regla([es_red_inalambrica, pc_si_detecta_red_wifi, conexion_no_funciona_aun_sin_seguridad, conexion_con_cable_directo_al_router_no_funciona, configuracion_router_modificada, senal_wifi_se_pierde_o_es_lenta, pc_y_router_usan_diferente_estandar_wifi], actualizar_hardware_wifi).
regla([es_red_inalambrica, pc_si_detecta_red_wifi, conexion_no_funciona_aun_sin_seguridad, conexion_con_cable_directo_al_router_no_funciona, configuracion_router_modificada, conexion_wifi_estable_pero_sin_acceso, otros_dispositivos_wifi_no_funcionan], fallo_general_router_o_internet).
regla([es_red_inalambrica, pc_si_detecta_red_wifi, conexion_no_funciona_aun_sin_seguridad, conexion_con_cable_directo_al_router_no_funciona, configuracion_router_modificada, conexion_wifi_estable_pero_sin_acceso, otros_dispositivos_wifi_si_funcionan], actualizar_driver_wifi).

% --- REGLAS PARA PROBLEMAS DE RED CABLEADA ---
regla([es_red_cableada, conexion_falla_de_forma_estable, se_instalo_hub_o_switch_nuevo], revisar_cable_crossover_uplink).
regla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_apagada], revisar_capa_fisica).
regla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_encendida, configuracion_ip_es_unica_o_automatica], clonar_configuracion_ip).
regla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_encendida, configuracion_ip_copiada_de_otra_pc, hay_error_en_administrador_dispositivos], reinstalar_driver_o_reemplazar_nic).
regla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_encendida, configuracion_ip_copiada_de_otra_pc, no_hay_error_en_administrador_dispositivos, se_probo_otro_puerto_y_funciona], puerto_del_switch_danado).
regla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_encendida, configuracion_ip_copiada_de_otra_pc, no_hay_error_en_administrador_dispositivos, no_se_probo_otro_puerto_switch, conexion_falla_con_alto_trafico], reemplazar_hub_o_revisar_servidor).
regla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_encendida, configuracion_ip_copiada_de_otra_pc, no_hay_error_en_administrador_dispositivos, no_se_probo_otro_puerto_switch, conexion_falla_independiente_del_trafico, pc_tambien_es_inestable_sin_red], problema_no_es_de_red).
regla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_encendida, configuracion_ip_copiada_de_otra_pc, no_hay_error_en_administrador_dispositivos, no_se_probo_otro_puerto_switch, conexion_falla_independiente_del_trafico, pc_es_estable_sin_red, problema_se_soluciona_con_cable_corto], cableado_de_pared_defectuoso).
regla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_encendida, configuracion_ip_copiada_de_otra_pc, no_hay_error_en_administrador_dispositivos, no_se_probo_otro_puerto_switch, conexion_falla_independiente_del_trafico, pc_es_estable_sin_red, problema_persiste_con_cable_corto, funciona_con_tarjeta_de_red_nueva], tarjeta_de_red_antigua_defectuosa).
gla([es_red_cableada, conexion_falla_de_forma_estable, no_se_instalo_hardware_nuevo, luz_de_enlace_nic_encendida, configuracion_ip_copiada_de_otra_pc, no_hay_error_en_administrador_dispositivos, no_se_probo_otro_puerto_switch, conexion_falla_independiente_del_trafico, pc_es_estable_sin_red, problema_persiste_con_cable_corto, problema_persiste_con_tarjeta_de_red_nueva], conflicto_software_o_virus).

% --- REGLAS PARA PROBLEMAS INTERMITENTES EN RED CABLEADA ---
regla([es_red_cableada, conexion_intermitente_o_aleatoria, problema_ocurre_al_mover_cable_de_red], revisar_conector_o_cable).
regla([es_red_cableada, conexion_intermitente_o_aleatoria, problema_no_depende_de_mover_cable, longitud_cable_supera_limite], agregar_repetidores_o_acortar_ruta).
regla([es_red_cableada, conexion_intermitente_o_aleatoria, problema_no_depende_de_mover_cable, longitud_cable_dentro_limite, se_probo_otro_puerto_y_funciona], puerto_del_switch_danado).


% =================================================================
% 3. MOTOR DE INFERENCIA (INFERENCE ENGINE)
% =================================================================
% Responsable de aplicar las reglas a los hechos para derivar conclusiones.
% No tiene conocimiento del dominio (redes), solo sabe cómo procesar reglas.

% Predicado principal del motor. Busca una conclusión para una lista de síntomas.
% Tiene éxito si encuentra una regla que se dispara. Falla si no encuentra ninguna.
inferir_solucion(SintomasObservados, TextoSolucion) :-
    % Busca una regla cuyas premisas coincidan exactamente con los síntomas observados
    regla(SintomasObservados, IDSolucion),
    % Una vez encontrada la regla, busca el texto de la solución asociada
    solucion(IDSolucion, TextoSolucion),
    !. 


% =================================================================
% 4. INTERFAZ DE USUARIO (USER INTERFACE)
% =================================================================
% Responsable de toda la interacción con el usuario final.

% --- Predicado principal para iniciar el diagnóstico ---
diagnosticar :-
    writeln('========================================================'),
    writeln('==    SISTEMA EXPERTO DE DIAGNÓSTICO DE RED         =='),
    writeln('========================================================'),
    nl,
    writeln('Bienvenido. Este sistema le ayudará a diagnosticar problemas de red.'),
    nl.

% --- Comandos disponibles para el usuario ---
ayuda :-
    writeln('--- Comandos Disponibles ---'),
    writeln('iniciar.             -> Comienza un nuevo diagnóstico.'),
    writeln('sintomas.            -> Muestra la lista de todos los síntomas posibles.'),
    writeln('ayuda.               -> Muestra este menú de ayuda.'),
    writeln('halt.                -> Cierra Prolog.'),
    nl.

iniciar :-
    sintomas, % Muestra los síntomas para que el usuario sepa qué escribir
    nl,
    writeln('Introduzca sus síntomas como una lista Prolog, terminando con un punto.'),
    writeln('Ejemplo: [es_red_cableada, conexion_intermitente_o_aleatoria, problema_ocurre_al_mover_cable_de_red].'),
    nl,
    write('Sus síntomas > '),
    read_term(SintomasUsuario, []),
    nl,
    procesar_diagnostico(SintomasUsuario).

% Procesa la lista de síntomas dada por el usuario
procesar_diagnostico(SintomasUsuario) :-
    writeln('--- Procesando... ---'),
    (   inferir_solucion(SintomasUsuario, TextoSolucion)
    ->  % Si el motor de inferencia tuvo éxito:
        mostrar_resultado(SintomasUsuario, TextoSolucion)
    ;   % Si el motor de inferencia falló:
        mostrar_no_encontrado(SintomasUsuario)
    ).

% Muestra el resultado exitoso
mostrar_resultado(Sintomas, Solucion) :-
    writeln('========================================================'),
    writeln('==                 DIAGNÓSTICO DE RED                 =='),
    writeln('========================================================'),
    format('~n[Síntomas Analizados]~n~w~n', [Sintomas]),
    nl,
    writeln('[Solución Recomendada]'),
    writeln(Solucion),
    writeln('========================================================'),
    nl.

% Muestra un mensaje cuando no se encuentra una solución
mostrar_no_encontrado(Sintomas) :-
    writeln('========================================================'),
    writeln('==           DIAGNÓSTICO NO ENCONTRADO              =='),
    writeln('========================================================'),
    format('~nNo se encontró una regla que coincida con la combinación exacta de síntomas:~n~w~n', [Sintomas]),
    writeln('========================================================'),
    nl.

% Muestra todos los síntomas disponibles
sintomas :-
    writeln('--- SÍNTOMAS DISPONIBLES EN LA BASE DE CONOCIMIENTO ---'),
    writeln('(Use estos identificadores para construir su lista)'),
    nl,
    forall(problema_red(ID, Desc), format('~w -> ~w~n', [ID, Desc])).

% Mensaje inicial al cargar el archivo
:- writeln('Sistema Experto de Redes cargado.'),
   writeln('Para empezar, escriba "diagnosticar." o "ayuda."').