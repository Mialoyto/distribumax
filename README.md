# **PROYECTO FINAL DISTRIBUMAX**

## Integrantes:

- Javier Castilla Maravi
- Alexander Loyola Torres
- Alexsis Soto Saravia


> Luego de crear la base de datos,tablas y procedimientos, debemos de hacer las inserciones de datos.
>El script 29.1 InserDatos.
>desde use distribumax, hasta el ultimo registro de productos, luego de ello realizamos el registro de una persona que esta en pruebas procedures y tambien el usuario,después de haber creado el usuario,se puede inicar sesión. 

### Luego de iniciar sesión, los procesos que registran son los siguientes:
- Registro de personas-Listado %80.
- Registro de Usuarios-Listado %80. 
- Registro de Empresas-Listado %70.
- Registro de Proveedores-Listado %60.
- Registro de Tipo Promoción-Listado %80.
- Registro de Marcas-Listado %70.
- Registro de Vehiculos-listado %60.
- Registro de Kardex %80.
- Registro de Pedidos %90.
- Registro de Ventas-Listado-Actualizar-Historial %80


**DEPENDECNIAS**
```
 composer install
```

**MODIFICACION DE PHP.ini**
 ```
  extension=fileinfo
  extension=gd
  extension=gettext
  extension=gmp
  extension=intl
  extension=imap
  extension=mbstring
  extension=exif
  extension=mysqli
```

**INSTALAR Dompdf**
 ```
 composer require dompdf/dompdf
```