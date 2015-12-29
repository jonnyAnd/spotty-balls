package ;
class Controller {

	private var _view:View;
	private var _model:Model;


	public function new(view:View, model:Model) {
		_view = view;
		_model = model;
	}
}
