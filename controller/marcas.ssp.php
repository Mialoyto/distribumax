<?php

/*
 * DataTables example server-side processing script.
 *
 * Please note that this script is intentionally extremely simple to show how
 * server-side processing can be implemented, and probably shouldn't be used as
 * the basis for a large complex system. It is suitable for simple use cases as
 * for learning.
 *
 * See https://datatables.net/usage/server-side for full details on the server-
 * side processing requirements of DataTables.
 *
 * @license MIT - https://datatables.net/license_mit
 */

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Easy set variables
 */

// DB table to use
$table = 'marcas';

// Table's primary key
$primaryKey = 'idmarca';

// Array of database columns which should be read and sent back to DataTables.
// The `db` parameter represents the column name in the database, while the `dt`
// parameter represents the DataTables column identifier. In this case simple
// indexes
$columns = array(
  array('db' => 'idmarca', 'dt' => 0),
  array('db' => 'idproveedor', 'dt' => 1),
  array('db' => 'marca', 'dt' => 2),
  array('db' => 'idcategoria', 'dt' => 3),
  array('db' => 'estado', 'dt' => 4)
);

// SQL server connection information
$sql_details = array(
  'user' => 'root',
  'pass' => '',
  'db'   => 'distribumax',
  'host' => 'localhost',
  'charset' => 'utf8' // Depending on your PHP and MySQL config, you may need this
);


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * If you just want to use the basic configuration for DataTables with PHP
 * server-side, there is no need to edit below this line.
 */

require('../model/ssp.class.php');
// header("Content-type: application/json; charset=utf-8");

try {
  $response = SSP::simple($_GET, $sql_details, $table, $primaryKey, $columns);
  echo json_encode($response);
} catch (Exception $e) {
  echo json_encode(array(
    "error" => $e->getMessage()
  ));
}
