<?php

require_once 'Conexion.php';

class Vehiculo extends Conexion
{
	private $pdo;

	public function __construct()
	{
		$this->pdo = parent::getConexion();
	}

	public function addVehiculo($params = [])
	{
		try {
			$status = false;
			$query = $this->pdo->prepare("CALL sp_registrar_vehiculo (?,?,?,?,?,?)");
			$status = $query->execute(array(

				$params['idusuario'],
				$params['marca_vehiculo'],
				$params['modelo'],
				$params['placa'],
				$params['capacidad'],
				$params['condicion']
			));

			return $status;
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}
	public function getAll()
	{
		try {
			$query = $this->pdo->prepare("CALL sp_listar_vehiculo");
			$query->execute();
			return $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function searchConductor($params = [])
	{
		try {
			$query = $this->pdo->prepare("CALL sp_buscar_conductor (?)");
			$query->execute(array($params['item']));
			return  $query->fetchAll(PDO::FETCH_ASSOC);
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function searchVehiculoDespacho($params = [])
	{
		try {
			$sql = "CALL sp_buscar_vehiculos(?)";
			$query = $this->pdo->prepare($sql);
			$query->execute(
				array(
					$params['item']
				)
			);
			$response = $query->fetchAll(PDO::FETCH_ASSOC);
			return $response;
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function updateVehiculo($params = [])
	{
		try {
			$query = $this->pdo->prepare("CALL sp_actualizar_vehiculo(?,?,?,?,?,?)");
			$query->execute(array(
				$params['idvehiculo'],
				$params['marca_vehiculo'],
				$params['modelo'],
				$params['placa'],
				$params['capacidad'],
				$params['condicion']
			));
			$resultado = $query->fetchAll(PDO::FETCH_ASSOC);
			return $resultado;
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function getVehiculo($params = [])
	{
		try {
			$query = $this->pdo->prepare("CALL sp_getVehiculo(?)");
			$query->execute(array(
				$params['idvehiculo']
			));
			$resultado = $query->fetchAll(PDO::FETCH_ASSOC);
			return $resultado;
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}

	public function updateEstadoVehiculo($params = [])
	{
		try {
			$sql = "CALL sp_update_estado_vehiculo(?,?)";
			$query = $this->pdo->prepare($sql);
			$query->execute(
				array(
					$params['idvehiculo'],
					$params['estado']
				)
			);
			$response = $query->fetchAll(PDO::FETCH_ASSOC);
			return $response;
		} catch (Exception $e) {
			die($e->getMessage());
		}
	}
}
// $vehiculo= new Vehiculo();
// $dato=[
//     'item'=>'a'
// ];
// echo json_encode($vehiculo->searchVehiculo($dato));