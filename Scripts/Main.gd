extends Control


####### USER VARIABLES #######

var data_path = "user://data.dat"
var current_user = "Joker"
var user_index


####### DATA VARIABLES #######

var data = {
	"User": [],
	"Password": [],
	"FavColour": []
}

var recipe = {
	
}



func _ready():
#	OS.shell_open(OS.get_user_data_dir())
	setup()
	load_data()




####### CREATION #######

func setup():
	set_background()
	create_title()
	set_categories()
	text_fields()
	log_reg_buttons()
	Create_Colour_Picker()
	create_logout()
	connect_signals()


func connect_signals():
	$LoginSystem/LoginButton.connect("pressed", self, "_on_login_pressed")
	$LoginSystem/RegisterButton.connect("pressed", self, "_on_register_pressed")
	$ColourPicker.connect("color_changed", self, "_on_ColourPicker_colour_changed")
	$Logout.connect("pressed", self, "_on_logout_pressed")


func set_categories():
	create_item("LoginSystem", Control, Vector2.ZERO, self)

func create_logout():
	create_item("Logout", TextureButton, Vector2(20,727), self)
	$Logout.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$Logout.visible = false
	var img = Image.new()
	img.load("res://Images/Logout.png")
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	$Logout.texture_normal = tex


func Create_Colour_Picker():
	create_item("ColourPicker", ColorPickerButton, Vector2(367,747), self, Vector2(26,20))
	$ColourPicker.visible = false
	$ColourPicker.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	create_item("ColourPickerLabel", Label, Vector2(330,727), self)
	$ColourPickerLabel.text = "Profile Colour"
	var font = DynamicFont.new()
	font.font_data = load("res://Font/RaspoutineDemiBold_TB.otf")
	font.size = 16
	font.use_filter = true
	font.outline_size = 1
	font.outline_color = Color.black
	$ColourPickerLabel.add_font_override("font", font)
	$ColourPickerLabel.add_color_override("font_color", Color.white)
	$ColourPickerLabel.visible = false


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
	var theme = load("res://Themes/ButtonTheme.tres")
	create_item("LoginButton", Button, Vector2(100,445), $LoginSystem, Vector2(80,10))
	$LoginSystem/LoginButton.text = "Login"
	$LoginSystem/LoginButton.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$LoginSystem/LoginButton.set_theme(theme)
	create_item("RegisterButton", Button, Vector2(285,445), $LoginSystem, Vector2(80,10))
	$LoginSystem/RegisterButton.text = "Register"
	$LoginSystem/RegisterButton.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$LoginSystem/RegisterButton.set_theme(theme)


func create_title():
	create_item("Title", Label, Vector2(125, 50), self)
	$Title.text = "Food Recipes"
	var font = DynamicFont.new()
	font.font_data = load("res://Font/RaspoutineDemiBold_TB.otf")
	font.size = 40
	font.use_filter = true
	font.outline_size = 1
	font.outline_color = Color.black
	$Title.add_font_override("font", font)
	$Title.add_color_override("font_color", Color.white)
	$Title.align = 1


func set_background():
	create_item("BG", TextureRect,Vector2(0,0), self)
	create_texture("res://Images/Background01.png", $BG)
	$BG.self_modulate = Color.darkgray
	create_item("BG2", TextureRect,Vector2(0,0), self)
	create_texture("res://Images/Background02.png", $BG2)
	$BG2.self_modulate = Color.darkorange




####### REUSABLE #######

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




####### SIGNALS #######

func _on_login_pressed():
	if $LoginSystem/UsernameField.text in data.User:
		user_index = data.User.find($LoginSystem/UsernameField.text)
		prints("user", $LoginSystem/UsernameField.text)
		
		if $LoginSystem/PasswordField.text.sha256_text() == data.Password[user_index]:
			$LoginSystem/PasswordField.text = $LoginSystem/PasswordField.text.sha256_text()
			yield(get_tree().create_timer(0.2),"timeout")
			print("Login Successful")
			$Title.text = "%s \nFood Recipes" %$LoginSystem/UsernameField.text
			current_user = $LoginSystem/UsernameField.text
			$LoginSystem/UsernameField.text = ""
			$LoginSystem/PasswordField.text = ""
			$LoginSystem.visible = false
			$ColourPicker.visible = true
			$ColourPickerLabel.visible = true
			$Logout.visible = true
			setup_recipes()
			print(user_index)
			
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
					$ColourPicker.color = Color(data.FavColour[user_index][0],
							data.FavColour[user_index][1],
							data.FavColour[user_index][2],
							data.FavColour[user_index][3])
					$BG2.self_modulate = Color(data.FavColour[user_index][0],
							data.FavColour[user_index][1],
							data.FavColour[user_index][2],
							data.FavColour[user_index][3])
					print(data.FavColour[user_index])
		
		elif $LoginSystem/UsernameField.text == "":
			print("invalid user")
		
		else:
			print("Incorrect username or password")
			
	else:
		print("No user found, please register")


func _on_register_pressed():
	if $LoginSystem/UsernameField.text in data.User:
		print("User already exists")

	elif " " in $LoginSystem/UsernameField.text or $LoginSystem/UsernameField.text == "":
		print("Username can not have spaces or be blank")
		
	else:
		if $LoginSystem/PasswordField.text == "":
			print("User accounts need a password")
			
		else:
			data.User.append($LoginSystem/UsernameField.text)
			data.Password.append($LoginSystem/PasswordField.text.sha256_text())
			data.FavColour.append([0,0,0,1])
			print(data)
			$LoginSystem/UsernameField.text = ""
			$LoginSystem/PasswordField.text = ""
			print("Registered user")
			save_data()


func _on_logout_pressed():
	get_tree().reload_current_scene()


func _on_ColourPicker_colour_changed(color):
	$BG2.self_modulate = color
	data.FavColour[user_index] = color
	save_data()




####### DATA #######

func save_data():
	var f = File.new()
	var path = "user://data.dat"
	f.open(path, f.WRITE)
	f.store_line(to_json(data))
	f.close()
#	OS.shell_open(OS.get_user_data_dir())


func load_data():
	var f= File.new()
	var path = "user://data.dat"
	if f.file_exists(path):
		f.open(path, f.READ)
		data = parse_json(f.get_as_text())
		f.close()
	else:
		pass


func save_recipe():
	var f = File.new()
	var path = "user://%s_recipe.rec" %current_user
	f.open(path, f.WRITE)
	f.store_line(to_json(recipe))
	f.close()
#	OS.shell_open(OS.get_user_data_dir())


func load_recipe():
	var f= File.new()
	var path = "user://%s_recipe.rec" %current_user
	f.open(path, f.READ)
	data = parse_json(f.get_as_text())
	f.close()


func setup_recipes():
	if has_node("./RecipeContainer"):
		print("RecipeContainer already exists")
	else:
		create_item("RecipeContainer",ScrollContainer,Vector2(150,250),self, Vector2(200,400))
		create_item("VContainer",VBoxContainer,Vector2(150,250),$RecipeContainer, Vector2(200,400))
		$RecipeContainer/VContainer.add_constant_override("separation", 20)
		var i = 0
		while i < recipe.size():
			var lab = Label.new()
			lab.text = "this is my text"
			$RecipeContainer/VContainer.add_child(lab)
			i+=1








