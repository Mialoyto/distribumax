<?php

$clave1='admin';
$clave2='SISTEMAS2024';
echo "Clave 1: $clave1<br>";
var_dump(password_hash($clave1,PASSWORD_BCRYPT));
echo "<hr>";
var_dump(password_hash($clave2,PASSWORD_BCRYPT));