extends Control


var data_path = "user://data.dat"
var current_user = "Joker"
var user_index

var data = {
	"User": [],
	"Password": [],
	"FavColour": []
}

var recipe = {
	
}



# Called when the node enters the scene tree for the first time.
func _ready():
#	OS.shell_open(OS.get_user_data_dir())
	setup()
	load_data(data_path)
	move_child($ColorPickerButton,3)


func setup():
	set_background()
	create_title()
	set_categories()
	text_fields()
	log_reg_buttons()
	connect_signals()


func connect_signals():
	$LoginSystem/LoginButton.connect("pressed", self, "_on_login_pressed")
	$LoginSystem/RegisterButton.connect("pressed", self, "_on_register_pressed")


func set_categories():
	create_item("LoginSystem", Control, Vector2.ZERO, self)


func text_fields():
	create_item("UsernameLabel", Label, Vector2(175,300), $LoginSystem)
	$LoginSystem/UsernameLabel.text = "Username:"
	$LoginSystem/UsernameLabel.self_modulate = Color.black
	create_item("UsernameField", LineEdit, Vector2(100,320), $LoginSystem, Vector2(250,10))
	$LoginSystem/UsernameField.placeholder_text = "Username"
	create_item("PasswordLabel", Label, Vector2(175,380), $LoginSystem)
	$LoginSystem/PasswordLabel.text = "Password:"
	$LoginSystem/PasswordLabel.self_modulate = Color.black
	create_item("PasswordField", LineEdit, Vector2(100,400), $LoginSystem, Vector2(250,10))
	$LoginSystem/PasswordField.placeholder_text = "Password"
	$LoginSystem/PasswordField.secret = true


func log_reg_buttons():
	create_item("LoginButton", Button, Vector2(100,435), $LoginSystem)
	$LoginSystem/LoginButton.text = "Login"
	create_item("RegisterButton", Button, Vector2(285,435), $LoginSystem)
	$LoginSystem/RegisterButton.text = "Register"


func create_title():
	create_item("Title", Label, Vector2(125, 20), self)
	$Title.text = "Food Recipes"
	var font = DynamicFont.new()
	font.font_data = load("res://Font/RaspoutineDemiBold_TB.otf")
	font.size = 40
	font.use_filter = true
	$Title.add_font_override("font", font)
	$Title.add_color_override("font_color", Color.white)
	$Title.align = 1


func set_background():
	create_item("BG", TextureRect,Vector2(0,0), self)
	create_texture("res://Images/Background01.png", $BG)
	$BG.self_modulate = Color.gray
	create_item("BG2", TextureRect,Vector2(0,0), self)
	create_texture("res://Images/Background02.png", $BG2)
	$BG2.self_modulate = Color.darkorange


func create_texture(path: String, obj):
	var img = Image.new()
	img.load(path)
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	obj.set_texture(tex)


func create_item(Name:String, Class, Position:Vector2, Parent, Size:Vector2 = Vector2.ZERO):
	var item = Class.new()
	item.set_name(Name)
	item.rect_position = Position
	item.rect_size = Size
	Parent.add_child(item)


func _on_login_pressed():
	if $LoginSystem/UsernameField.text in data.User:
		user_index = data.User.find($LoginSystem/UsernameField.text)
		
		if $LoginSystem/PasswordField.text.sha256_text() == data.Password[user_index]:
			print("Login Successful")
			$Title.text = "%s \nFood Recipes" %$LoginSystem/UsernameField.text
			current_user = $LoginSystem/UsernameField.text
			$LoginSystem/UsernameField.text = ""
			$LoginSystem/PasswordField.text = ""
			$LoginSystem.visible = false
			
			if File.new().file_exists("user://data.dat"):
				print(user_index <= data.FavColour.size()-1)
				if user_index <= data.FavColour.size()-1:
					print("inr ange")
					
					if typeof(data.FavColour[user_index]) == TYPE_STRING:
						var tmp = data.FavColour[user_index]
						tmp = tmp.split(",")
						data.FavColour[user_index] = tmp

					else:
						pass
					$ColorPickerButton.color = Color(data.FavColour[user_index][0],
							data.FavColour[user_index][1],
							data.FavColour[user_index][2],
							data.FavColour[user_index][3])
					$BG2.self_modulate = Color(data.FavColour[user_index][0],
							data.FavColour[user_index][1],
							data.FavColour[user_index][2],
							data.FavColour[user_index][3])
					print(data.FavColour[user_index])
			
		else:
			print("Incorrect username or password")
			
	else:
		print("No user found, please register")


func _on_register_pressed():
	if $LoginSystem/UsernameField.text in data.User:
		print("User already exists")
		
	else:
		data.User.append($LoginSystem/UsernameField.text)
		data.Password.append($LoginSystem/PasswordField.text.sha256_text())
		data.FavColour.append([0,0,0,0])
		print(data)
		$LoginSystem/UsernameField.text = ""
		$LoginSystem/PasswordField.text = ""
		print("Registered user")
		save_data(data_path)


func save_data(path):
	var f = File.new()
	f.open(path, f.WRITE)
	f.store_line(to_json(data))
	f.close()
#	OS.shell_open(OS.get_user_data_dir())


func load_data(path):
	var f= File.new()
	if f.file_exists(path):
		f.open(path, f.READ)
		data = parse_json(f.get_as_text())
		f.close()
	else:
		pass


func save_recipe(path):
	var f = File.new()
	f.open(path, f.WRITE)
	f.store_line(to_json(recipe))
	f.close()
#	OS.shell_open(OS.get_user_data_dir())


func load_recipe(path):
	var f= File.new()
	f.open(path, f.READ)
	data = parse_json(f.get_as_text())
	f.close()


func _on_ColorPickerButton_color_changed(color):
	$BG2.self_modulate = color
	data.FavColour[user_index] = color
	save_data(data_path)
