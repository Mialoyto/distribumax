<?php

$clave1='jefe_mercaderia';
$clave2='admin';
echo "Clave 1: $clave1<br>";
var_dump(password_hash($clave1,PASSWORD_BCRYPT));
echo "<hr>";
echo "Clave 2: $clave2<br>";
var_dump(password_hash($clave2,PASSWORD_BCRYPT));
echo "<hr>";
echo 'La versión de PHP es: ' . phpversion();

