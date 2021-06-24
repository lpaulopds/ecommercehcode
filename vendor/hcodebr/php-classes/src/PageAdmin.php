<?php
	namespace Hcode;
	// A classe PageAdmin extende da classe Page.
	// Com a diferença que é preciso criar um novo repositorio com a variavel $tpl_dir
	class PageAdmin extends Page {
		public function __construct($opts = array(), $tpl_dir = "/ecommerce/views/admin/") {
			// copia(herança) o metodo construtor da classe Page(classe pai)
			parent::__construct($opts, $tpl_dir);
		}
	}
?>