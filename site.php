<?php

	use \Hcode\Page; // Chama a função construct da page.php
	use \Hcode\Model\Product;
	use \Hcode\Model\Category;
	use \Hcode\Model\Cart;

	$app->get('/', function() {

		$products = Product::listAll();

	    // Variavel obrigatoria que chama o header e o footer. Chama o metodo construct na tela
		$page = new Page();

		$page->setTpl("index", [
			'products'=>Product::checklist($products)
		]);
	});

	$app->get('/categories/:idcategory', function($idcategory) {

		$page = (isset($_GET['page'])) ? (int)$_GET['page'] : 1;

		$category = new Category();

		$category->get((int)$idcategory);

		$pagination = $category->getProductsPage($page);

		$pages = [];

		for ($i=1; $i <= $pagination['pages']; $i++) { 
			array_push($pages, [
				'link'=>'/ecommerce/categories/'.$category->getidcategory().'?page'.$i,
				'page'=>$i
			]);
		}

		$page = new Page();

		$page->setTpl("category", [
			'category'=>$category->getValues(),
			'products'=>$pagination["data"],
			'pages'=>$pages
		]);
	});

	$app->get('/products/:desurl', function($desurl) {

	$product = new Product();

	$product->getFromURL($desurl);

	$page = new Page();

	$page->setTpl("product-detail", [

		'product'=>$product->getValues(),
		'categories'=>$product->getCategories()
		]);
	});

	$app->get("/cart/", function() {

		$cart = Cart::getFromSession();

		$page = new Page();

		// var_dump($cart->getValues());
		// exit;

		// var_dump($cart->getProducts());
		// exit;

		$page->setTpl("cart", [
			'cart'=>$cart->getValues(),
			'products'=>$cart->getProducts(),
			'error'=>Cart::getMsgError()
		]);
	});

	$app->get("/cart/:idproduct/add", function($idproduct) {

		$product = new Product();

		$product->get((int)$idproduct);

		$cart = Cart::getFromSession();

		$qtd = (isset($_GET['qtd'])) ? (int)$_GET['qtd'] : 1;

		for ($i = 0; $i < $qtd; $i++) {

			$cart->addProduct($product);
		}

		header("Location: /ecommerce/cart");
		exit;
	});

	$app->get("/cart/:idproduct/minus", function($idproduct) {

		$product = new Product();

		$product->get((int)$idproduct);

		$cart = Cart::getFromSession();

		$cart->removeProduct($product);

		header("Location: /ecommerce/cart");
		exit;
	});

	$app->get("/cart/:idproduct/remove", function($idproduct) {

		$product = new Product();

		$product->get((int)$idproduct);

		$cart = Cart::getFromSession();

		$cart->removeProduct($product, true);

		header("Location: /ecommerce/cart");
		exit;
	});

	$app->post("/cart/freight", function() {

		$cart = Cart::getFromSession();

		$cart->setFreight($_POST['zipcode']);

		header("Location: /ecommerce/cart");
		exit;
	});
?>