# Autocars 
## Proyecto Angular 12 y PHP yolanda
Este es mi proyecto de programación web de primero de DAW.
En este proyecto el framework de Angular 12 y mi propio framework de php backend
### Caracteristicas
* PHP 8.0 framework por módulos
* Angular 12

### Docker
Para iniciar los contenedores
```console
docker-compose up
```

## Caracteristicas principales
- Home
- Shop
	- Filtros
	- Favoritos
	- Paginación
- Login
- Register
- Recover password
- Verify
- Social login
	- Gmail
	- Github
- Carrito
	- Checkout
- Mailjet

## Mejoras
- Angular 12 con Typescript
	- Guards: Auth guard
	- i18n (traducciones)
	- Filtros en la url
	- Popup component
	- Stock, no poder comprar más
	- Botones profesionales firebase social login
	- EventBus service (rxjs)
- PHP 8.0 framework propio por modulos
	- Protección sql injection (database.php)
	- Procedures MYSQL: 
		- createCar: Crear coche
		- deleteCar: Borrar coche
		- userSignup: Registrar un nuevo usuario
		- userSignin: Logearse 
		- userChangePassword: Cambiar contraseña de un usuario
		- userSocialSignin: Social signin
		- searchCar: Buscar coches con filtros
		- setFavoriteCar: Poner coche a favoritos
		- unsetFavoriteCar: Quitar coche de favoritos
		- getCart: Obtener carrito
		- addToCart: Añadir al carrito
		- delFromCart: Eliminar del carrito
		- getCart: Obtener carrito de un usuario
		- cartCheckout: Facturar carrito
	- Tirar excepciones 45000 de mysql al cliente
		- Utils, jsons, middlewares 
	- Comprobación token firebase 
	- Expiración JWT 
	- Atributos y tipado de php 8.0
	- App -> Call_action (transformar el body http y llamar al controlador con parametros)
	- App -> Call_attributes (cargar librerias, midlewares, utils)
- Servidor nginx con proxy a ng serve
- Dockerizado: docker-compose.yml y Dockerfile
