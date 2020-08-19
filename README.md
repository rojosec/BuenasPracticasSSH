## Buenas Prácticas SSH

Este es un script desarrollado en BASH para la implementación de buenas practicas en el protocolo SSH.


### Acerca de

OpenSSH (Open Secure Shell) es un protocolo de comunicación cifrado, el cual permite a los usuarios establecer conexiones seguras punto a punto.

Es importante tener en cuenta que siendo cifrado este mismo, se deben implementar buenas practicas para el aprovisionamiento seguro del usuario e información.


### Contenido del script ( Buenas practicas )

* Verificación de la version del protocolo ( por defecto debe ser 2.0 )
* Cambio de contraseña (es necesario que implemente una contraseña ROBUSTA).
* Cambio de puerto.
* Limitación de acceso por usuarios.
* Desactivar acceso root.
* Autenticación mediante llaves ( publica y privada )

### Detalles de implementación

Cuando el script termine su ejecución usted podra ver reflejado los cambios en su archivo de configuración, que se ubica en la siguiente ruta ( /etc/ssh/sshd_config ), tengo que hacer enfasis en que todo esta configuración la encontrara al final de este mismo.