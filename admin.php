<?php

	use \Hcode\PageAdmin;
	use \Hcode\Model\User;
	use \Hcode\Model\Category;

	$app->get('/admin/', function() {

		User::verifyLogin();

	    // Variavel obrigatoria que chama o header e o footer. Chama o metodo construct na tela
		$page = new PageAdmin();

		$page->setTpl("index");
	});

	$app->get('/admin/login', function() {

		$page = new PageAdmin([
			"header"=>false,
			"footer"=>false
		]);

		$page->setTpl("login");
	});

	$app->post('/admin/login', function() {

		User::login($_POST["login"], $_POST["password"]);

		header("Location: ../admin");
		exit;
	});

	$app->get('/admin/logout', function() {

		User::logout();

		header("Location: ../admin");
		exit;
	});

	$app->get('/admin/forgot', function(){
		
		$page = new PageAdmin([
			"header"=>false,
			"footer"=>false
		]);

		$page->setTpl("forgot");
	});

	$app->post("/admin/forgot", function() {

		$user = User::getforgot($_POST["email"]);

		header("Location: ../admin/forgot/sent");
		exit;
	});

	$app->get("/admin/forgot/sent", function(){

		$page = new PageAdmin([
		"header"=>false,
		"footer"=>false
	]);

		$page->setTpl("forgot-sent");
	});


	$app->get("/admin/forgot/reset", function(){

		$user = User::validForgotDecrypt($_GET["code"]);

		$page = new PageAdmin([
			"header"=>false,
			"footer"=>false
		]);

		$page->setTpl("forgot-reset", array(
			"name"=>$user["desperson"],
			"code"=>$_GET["code"]
		));
	});

	$app->post("/admin/forgot/reset", function(){

		$forgot = User::validForgotDecrypt($_POST["code"]);	

		User::setFogotUsed($forgot["idrecovery"]);

		$user = new User();

		$user->get((int)$forgot["iduser"]);

		$password = User::getPasswordHash($_POST["password"]);

		$user->setPassword($password);

		$page = new PageAdmin([
			"header"=>false,
			"footer"=>false
		]);

		$page->setTpl("forgot-reset-success");
	});

	$app->get('/admin/categories', function() {

		User::verifyLogin();

		$categories = Category::listAll();

		$page = new PageAdmin();
		
		$page->setTpl("categories",[
			'categories'=>$categories
		]);
	});
?>