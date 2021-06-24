<?php

	use \Hcode\PageAdmin;
	use \Hcode\Model\User;
	
	$app->get('/admin/users', function() {

		User::verifyLogin();

		$users = User::listAll();

		$page = new PageAdmin();

		$page->setTpl("users", array(
			"users"=>$users
		));
	});

	$app->get('/admin/users/create', function() {

		User::verifyLogin();
		// Rota da página quebra, por isso é preciso declarar o header e footer como false
		// e incluir os códigos na própria página. 
		$page = new PageAdmin();

		$page->setTpl("users-create");
	});

	$app->get('/admin/users/:iduser/delete', function($iduser) {

		User::verifyLogin();

		$user = new User();

		$user->get((int)$iduser);

		$user->delete();

		header("Location: ../../../admin/users");
		exit;
	});
						  	// :iduser na rota mostra ao php quais dados mostrar na tela quando essa determinada rota
						  	// A variavel $iduser é a responsável em pegar esses dados e jogar na rota com :ideuser
	$app->get('/admin/users/:iduser', function($iduser) {

		User::verifyLogin();

		$user = new User();

		$user->get((int)$iduser);
		// Rota da página quebra, por isso é preciso declarar o header e footer como false
		// e incluir os códigos na própria página. 
		$page = new PageAdmin();

		$page->setTpl("users-update", array(
			"user"=>$user->getValues()
		));
	});

	$app->post('/admin/users/create', function() {

	 	User::verifyLogin();

		$user = new User();

	 	$_POST["inadmin"] = (isset($_POST["inadmin"])) ? 1 : 0;

	 	$_POST['despassword'] = password_hash($_POST["despassword"], PASSWORD_DEFAULT, [

	 		"cost"=>12
	 	]);

	 	$user->setData($_POST);

		$user->save();

		header("Location: ../../admin/users");
	 	exit;
	});

	$app->post('/admin/users/:iduser', function($iduser) {

		User::verifyLogin();

		$user = new User();

		// Validação para saber se é ou não administrador
		$_POST["inadmin"] = (isset($_POST["inadmin"]))?1:0;

		$user->get((int)$iduser);

		$user->setData($_POST);

		$user->update();

		header("Location: ../../admin/users");
		exit;
	});

?>