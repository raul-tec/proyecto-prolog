%% MOTOR DE INFERENCIA

% https://www.experts-exchange.com/articles/30616/Wireless-network-troubleshooter-and-flowchart.html

% Predicado principal para iniciar el diagnóstico
diagnosticar :-
    writeln('======================================================'),
    writeln('==  Sistema Experto de Diagnóstico de Red Inalámbrica =='),
    writeln('======================================================'),
    writeln('Por favor, responda a las siguientes preguntas con "si" o "no".'), nl,
    nodo_inicial(Inicio), % Encuentra el punto de partida en la Base de Conocimiento
    resolver(Inicio).     % Llama al motor de resolución con el nodo inicial

% Motor de resolución recursivo
% Caso base: Si el nodo actual es una solución, la muestra y termina.
resolver(NodoID) :-
    nodo(NodoID, solucion, Texto),
    !, 
    nl,
    writeln('------------------- DIAGNÓSTICO DE RED -------------------'),
    writeln(Texto),
    writeln('----------------------------------------------------------').

% Paso recursivo: Si el nodo es una pregunta, la hace y sigue la transición.
resolver(NodoID) :-
    nodo(NodoID, pregunta, Texto),
    preguntar(Texto, Respuesta),
    transicion(NodoID, Respuesta, SiguienteNodoID),
    resolver(SiguienteNodoID).

% Si no hay transición para la respuesta dada, informa al usuario.
resolver(NodoID) :-
    nodo(NodoID, pregunta, _),
    writeln('No se encontró una ruta de diagnóstico para esa respuesta. Fin del proceso.').

%% INTERFAZ DE USUARIO

% Predicado para hacer una pregunta y obtener una respuesta (si/no)
preguntar(Pregunta, Respuesta) :-
    write(Pregunta), write(' (si/no)? '),
    read_line_to_string(user_input, RawInput),
    string_lower(RawInput, Input),
    (   (Input = "si" ; Input = "s")
    ->  Respuesta = si
    ;   (Input = "no" ; Input = "n")
    ->  Respuesta = no
    ;   writeln('Respuesta no válida. Por favor, responda "si" o "no".'),
        preguntar(Pregunta, Respuesta)
    ).

%% BASE DE CONOCIMIENTO

% --- Definición del nodo inicial ---
nodo_inicial(p_ve_la_red).

% --- Definición de todos los nodos (preguntas y soluciones) ---
% Formato: nodo(ID_Unico, tipo(pregunta/solucion), 'Texto para el usuario').

% Preguntas
nodo(p_ve_la_red,          pregunta, '¿Tu dispositivo detecta la red inalámbrica a la que quieres conectarte?').
nodo(p_otros_dispositivos, pregunta, '¿Otros dispositivos (móviles, portátiles) en la misma ubicación SÍ pueden ver la red?').
nodo(p_en_rango,           pregunta, '¿Estás seguro de que el dispositivo está dentro del alcance del router?').
nodo(p_ssid_oculto,        pregunta, '¿Es posible que la red esté configurada como "oculta" (SSID oculto)?').
nodo(p_es_compatible,      pregunta, '¿Tu tarjeta de red es compatible con el tipo de red del router (ej. Wi-Fi 6, 5GHz)?').
nodo(p_ve_red_ahora,       pregunta, 'Después de esperar a que el router se inicie, ¿puedes ver la red?').
nodo(p_interruptor_wifi,   pregunta, '¿Has verificado que el interruptor físico o el botón de Wi-Fi de tu dispositivo esté encendido?').
nodo(p_ve_otras_redes,     pregunta, '¿Tu dispositivo puede ver OTRAS redes Wi-Fi (las de tus vecinos, por ejemplo)?').
nodo(p_puede_conectar,     pregunta, '¿Puedes conectar exitosamente a la red (aunque no tengas internet)?').
nodo(p_contrasena_ok,      pregunta, '¿Estás completamente seguro de que la contraseña que estás introduciendo es la correcta?').
nodo(p_accede_internet,    pregunta, '¿Puedes acceder a páginas web como google.com?').
nodo(p_ping_gateway,       pregunta, 'Abre una terminal y haz "ping" a tu router (ej. ping 192.168.1.1). ¿Recibes respuesta?').
nodo(p_dhcp_activado,      pregunta, '¿La configuración de red de tu dispositivo está en "Obtener una dirección IP automáticamente" (DHCP)?').
nodo(p_ping_externo,       pregunta, 'Ahora haz un ping a una IP externa (ej. ping 8.8.8.8). ¿Recibes respuesta?').
nodo(p_usa_proxy,          pregunta, '¿Estás usando un servidor proxy en tu navegador o sistema?').
nodo(p_conexion_lenta,     pregunta, '¿La conexión es lenta o se corta de forma intermitente?').

% Soluciones / Acciones
nodo(s_acercarse,          solucion, 'SOLUCIÓN: Acerca tu dispositivo al router e intenta de nuevo. La señal puede ser demasiado débil.').
nodo(s_mostrar_ssid,       solucion, 'SOLUCIÓN: En la configuración del router, haz visible la red o conéctate manualmente introduciendo el nombre exacto de la red y la contraseña.').
nodo(s_cambiar_modo,       solucion, 'SOLUCIÓN: Cambia el modo de red del router a uno más compatible (ej. "modo mixto" b/g/n/ac) o adquiere un adaptador de red más moderno.').
nodo(s_reiniciar_router,   solucion, 'ACCIÓN: Reinicia el router. Desenchúfalo, espera 15 segundos y vuelve a enchufarlo.').
nodo(s_reseteo_fabrica,    solucion, 'SOLUCIÓN: Realiza un reseteo de fábrica en el router. Si el problema persiste, es probable que el router esté dañado.').
nodo(s_exito_reinicio,     solucion, '¡ÉXITO! El problema era temporal y se ha solucionado reiniciando el router. Ahora puedes conectarte.').
nodo(s_activar_interruptor,solucion, 'SOLUCIÓN: Activa el interruptor o botón de Wi-Fi de tu dispositivo.').
nodo(s_filtro_mac,         solucion, 'DIAGNÓSTICO: El problema puede ser un filtrado MAC en el router. Verifica que la dirección MAC de tu dispositivo no esté bloqueada.').
nodo(s_instalar_drivers,   solucion, 'SOLUCIÓN: Reinstala o actualiza los drivers de tu adaptador de red inalámbrica desde la web del fabricante.').
nodo(s_verificar_contra,   solucion, 'SOLUCIÓN: Verifica la contraseña del Wi-Fi. Revisa mayúsculas, minúsculas y símbolos.').
nodo(s_activar_dhcp,       solucion, 'SOLUCIÓN: Cambia la configuración de red de tu dispositivo a "Obtener una dirección IP automáticamente" (DHCP) y reconecta.').
nodo(s_problema_isp,       solucion, 'DIAGNÓSTICO: Hay un problema con tu servicio de Internet. Reinicia el módem y el router. Si no se soluciona, contacta a tu proveedor de Internet (ISP).').
nodo(s_problema_dns,       solucion, 'DIAGNÓSTICO: El problema es el DNS. SOLUCIÓN: Configura manualmente los DNS en tu dispositivo a unos públicos como 8.8.8.8 y 8.8.4.4 (Google).').
nodo(s_desactivar_proxy,   solucion, 'SOLUCIÓN: Desactiva el servidor proxy en la configuración de red de tu sistema o navegador.').
nodo(s_conexion_inestable, solucion, 'DIAGNÓSTICO: La conexión es inestable. SOLUCIÓN: Intenta acercarte al router o cambia el canal Wi-Fi en la configuración del router a uno menos congestionado.').
nodo(s_exito_final,        solucion, 'ÉXITO. Tu conexión a internet parece funcionar correctamente.').

% --- Definición de las transiciones (los caminos del diagrama) ---
% Formato: transicion(ID_Origen, respuesta_usuario, ID_Destino).

transicion(p_ve_la_red,          si, p_puede_conectar).
transicion(p_ve_la_red,          no, p_otros_dispositivos).

transicion(p_otros_dispositivos, si, p_interruptor_wifi).
transicion(p_otros_dispositivos, no, p_en_rango).

transicion(p_en_rango,           si, p_ssid_oculto).
transicion(p_en_rango,           no, s_acercarse).

transicion(p_ssid_oculto,        si, s_mostrar_ssid).
transicion(p_ssid_oculto,        no, p_es_compatible).

transicion(p_es_compatible,      si, s_reiniciar_router). % Simplificado a una acción directa
transicion(p_es_compatible,      no, s_cambiar_modo).

transicion(p_interruptor_wifi,   si, p_ve_otras_redes).
transicion(p_interruptor_wifi,   no, s_activar_interruptor).

transicion(p_ve_otras_redes,     si, s_filtro_mac).
transicion(p_ve_otras_redes,     no, s_instalar_drivers).

transicion(p_puede_conectar,     si, p_accede_internet).
transicion(p_puede_conectar,     no, p_contrasena_ok).

transicion(p_contrasena_ok,      si, s_filtro_mac).
transicion(p_contrasena_ok,      no, s_verificar_contra).

transicion(p_accede_internet,    si, p_conexion_lenta).
transicion(p_accede_internet,    no, p_ping_gateway).

transicion(p_ping_gateway,       si, p_ping_externo).
transicion(p_ping_gateway,       no, p_dhcp_activado).

transicion(p_dhcp_activado,      si, s_reiniciar_router).
transicion(p_dhcp_activado,      no, s_activar_dhcp).

transicion(p_ping_externo,       si, p_usa_proxy).
transicion(p_ping_externo,       no, s_problema_isp).

transicion(p_usa_proxy,          si, s_desactivar_proxy).
transicion(p_usa_proxy,          no, s_problema_dns).

transicion(p_conexion_lenta,     si, s_conexion_inestable).
transicion(p_conexion_lenta,     no, s_exito_final).