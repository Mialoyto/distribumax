<?php

$clave1='SENATI2024';
$clave2='SISTEMAS2024';

var_dump(password_hash($clave1,PASSWORD_BCRYPT));
echo "<hr>";
var_dump(password_hash($clave2,PASSWORD_BCRYPT));