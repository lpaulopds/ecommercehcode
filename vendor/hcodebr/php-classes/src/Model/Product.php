<?php
	namespace Hcode\Model;

	use \Hcode\DB\Sql;
	use \Hcode\Model;
	use \Hcode\Mailer;

	class Product extends Model {

		public static function listAll() {
			
			$sql = new Sql();
			return $sql->select("SELECT * FROM tb_products ORDER BY desproduct");
		}

		// Checa a lista de produtos cadastrados e inclui na seção de produtos da home do site 
		// Loop na página index.html
		public static function checklist($list) {

			foreach ($list as &$row) {
				
				$p = new Product();
				$p->setData($row);

				$row = $p->getValues();
			}

			return $list;
		}

		public function save() {

			$sql = new Sql();
			// CALL sp_users_save chama a procedure que chama todos os dados e joga no banco de uma só vez.
			$results = $sql->select("CALL sp_products_save(:idproduct, :desproduct, :vlprice, :vlwidth, :vlheight, :vllength, :vlweight, :desurl)", array(
				// O metodo setData faz o papel de gerar automaticamente os geters and seters
				":idproduct"=>$this->getidproduct(),
				":desproduct"=>$this->getdesproduct(),
				":vlprice"=>$this->getvlprice(),
				":vlwidth"=>$this->getvlwidth(),
				":vlheight"=>$this->getvlheight(),
				":vllength"=>$this->getvllength(),
				":vlweight"=>$this->getvlweight(),
				":desurl"=>$this->getdesurl()
			));

			$this->setData($results[0]);
		}

		public function get($idproduct) {
			
			$sql = new Sql();
			$results = $sql->select("SELECT * FROM tb_products WHERE idproduct = :idproduct", [
				":idproduct"=>$idproduct
			]);

			$this->setData($results[0]);
		}

		public function delete() {

			$sql = new Sql();

			$sql->query("DELETE FROM tb_products WHERE idproduct = :idproduct", [
				":idproduct"=>$this->getidproduct()
			]);
		}

		public function checkPhoto() {

			if (file_exists($_SERVER['DOCUMENT_ROOT'] . DIRECTORY_SEPARATOR .
				"ecommerce" . DIRECTORY_SEPARATOR .
				"res" . DIRECTORY_SEPARATOR .
				"site" . DIRECTORY_SEPARATOR .
				"img" . DIRECTORY_SEPARATOR .
				"products" . DIRECTORY_SEPARATOR .
				$this->getidproduct() . ".jpg"
			)) {

				$url = "/ecommerce/res/site/img/products/" . $this->getidproduct() . ".jpg";
			} else {

				$url = "/ecommerce/res/site/img/product.jpg";
			}

			return $this->setdesphoto($url);
		}

		public function getValues() {

			$this->checkPhoto();

			$values = parent::getValues();
			
			return $values;
		}

		public function setPhoto($file) {

			$extension = explode('.', $file["name"]);
			$extension = end($extension);

			switch ($extension) {
				case "jpg":
				case "jpeg":
				$image = imagecreatefromjpeg($file["tmp_name"]);

			break;
				case "gif":
				$image = imagecreatefromgif($file["tmp_name"]);

			break;
				case "png":
				$image = imagecreatefrompng($file["tmp_name"]);

			break;
			}

			$dist = $_SERVER['DOCUMENT_ROOT'] . DIRECTORY_SEPARATOR .
				"ecommerce" . DIRECTORY_SEPARATOR .
				"res" . DIRECTORY_SEPARATOR .
				"site" . DIRECTORY_SEPARATOR .
				"img" . DIRECTORY_SEPARATOR .
				"products" . DIRECTORY_SEPARATOR .
				$this->getidproduct() . ".jpg";

			imagejpeg($image, $dist);

			imagedestroy($image);

			$this->checkPhoto();
		}

		public function getFromURL($desurl) {

			$sql = new Sql();

			$rows = $sql->select("SELECT * FROM tb_products WHERE desurl = :desurl LIMIT 1", [
				':desurl'=>$desurl
			]);

			$this->setData($rows[0]);
		}

		public function getCategories() {

			$sql = new Sql();

			return $sql->select("
				SELECT * FROM tb_categories a INNER JOIN tb_productscategories b ON a.idcategory = b.idcategory WHERE b.idproduct = :idproduct
			", [
				':idproduct'=>$this->getidproduct()
			]);
		}

	}
?>