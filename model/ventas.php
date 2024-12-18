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
			$query = $this->pdo->prepare("CALL sp_registrar_venta(?,?,?,?,?,?,?,?) ");
			$id = $query->execute(array(
				$params['idpedido'],
				$params['idusuario'],
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
			$sql = "CALL sp_condicion_venta (?,?)";
			$query = $this->pdo->prepare($sql);
			$status = $query->execute(array(
				$params['condicion'],
				$params['idventa']
			));
			return $status;
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function UpdateEstado($params = [])
	{
		try {
			$query = $this->pdo->prepare("CALL sp_estado_venta(?,?)");
			$query->execute(array(
				$params['estado'],
				$params['idventa']
			));
			return $query->rowCount();
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
	public function listar_fecha($params = [])
	{
		try {
			$query = $this->pdo->prepare("CALL sp_listar_fecha(?)");
			$query->execute(array($params['fecha_venta']));
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

	public function buscarventa($params = [])
	{
		try {
			$query = $this->pdo->prepare("call sp_buscar_venta(?)");
			$query->execute(array($params['item']));
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function getventas($params = [])
	{
		try {
			$query = $this->pdo->prepare("call sp_getventas(?)");
			$query->execute(array(
				$params['provincia']
			));

			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}
	public function  ventasDay($params = [])
	{
		try {
			$query = $this->pdo->prepare("CALL sp_VentasPorDia(?)");
			$query->execute(array($params['fecha']));
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}
	public function ventastotales()
	{
		try {
			$query = $this->pdo->prepare("CALL sp_Ventastotales");
			$query->execute();
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function conteoVentas()
	{
		try {
			$query = $this->pdo->prepare("CALL sp_contar_ventas");
			$query->execute();
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	/* SECTION */
	// Esta funcion cancela la venta y regresa los productos al lote de donde salieron
	public function cancelarVenta($params = [])
	{
		try {
			$sql = "CALL sp_condicion_venta (?, ?, ?)";
			$query = $this->pdo->prepare($sql);
			$query->execute(array(
				$params['condicion'],
				$params['idventa'],
				$params['idpedido']
			));
			$response = $query->fetchAll(PDO::FETCH_ASSOC);
			return $response;
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}
}
