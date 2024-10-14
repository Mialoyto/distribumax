<?php

require_once 'Conexion.php';

class Ventas extends Conexion
{
	private $pdo;

	public function __construct()
	{
		$this->pdo = parent::getConexion();
	}
	public function addVentas($params = []): int
	{
		try {
			$id = -1;
			$query = $this->pdo->prepare("CALL sp_registrar_venta(?,?,?,?,?,?,?) ");
			$id = $query->execute(array(
				$params['idpedido'],
				$params['idtipocomprobante'],
				$params['fecha_venta'],
				$params['subtotal'],
				$params['descuento'],
				$params['igv'],
				$params['total_venta']
			));
			$row = $query->fetch(PDO::FETCH_ASSOC);
			return $row['idventa'];
		} catch (Exception $e) {
			return $id;
		}
	}
	public function upVenta($params = [])
	{
		try {
			$status = false;
			$sql = "CALL sp_estado_venta (?,?)";
			$query = $this->pdo->prepare($sql);
			$status = $query->execute(array(
				$params['estado'],
				$params['idventa']
			));
			return $status;
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function getAll()
	{
		try {
			$query = $this->pdo->prepare("CALL sp_listar_ventas");
			$query->execute();
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}
	public function historial()
	{
		try {
			$sql = "CALL sp_historial_ventas";
			$query = $this->pdo->prepare($sql);
			$query->execute();
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}
	public function reporteVenta($params = [])
	{
		try {
			$query = $this->pdo->prepare("CALL sp_generar_reporte(?)");
			$query->execute(array(
				$params['idventa']
			));
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function getByID($params = [])
	{
		try {
			$sql = "CALL sp_getById_venta(?)";
			$query = $this->pdo->prepare($sql);
			$query->execute(array(
				$params['idventa']
			));
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}
}
