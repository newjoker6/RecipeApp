extends Control


####### USER VARIABLES #######

var current_user = "Joker"
var user_index


####### DATA VARIABLES #######

var data = {
	"User": [],
	"Password": [],
	"FavColour": []
}

var recipe = {
	"FoodImage": ["res://icon.png"],
	"Name": ["My Recipe"]
}



func _ready():
#	OS.shell_open(OS.get_user_data_dir())
	setup()
	load_data()
	var dir = Directory.new()
	dir.copy("res://Images/Background01.png", "user://Background01.png")
	dir.copy("res://Images/Background02.png", "user://Background02.png")
	dir.copy("res://Images/Logout.png", "user://Logout.png")




####### CREATION #######

func setup():
	set_background()
	create_title()
	set_categories()
	text_fields()
	log_reg_buttons()
	Create_Colour_Picker()
	create_logout()
	add_recipe_button()
	connect_signals()


func connect_signals():
	$LoginSystem/LoginButton.connect("pressed", self, "_on_login_pressed")
	$LoginSystem/RegisterButton.connect("pressed", self, "_on_register_pressed")
	$ColourPicker.connect("color_changed", self, "_on_ColourPicker_colour_changed")
	$Logout.connect("pressed", self, "_on_logout_pressed")
	$AddRecipe.connect("pressed", self, "_on_add_recipe_pressed")
	


func set_categories():
	create_item("LoginSystem", Control, Vector2.ZERO, self)

func create_logout():
	create_item("Logout", TextureButton, Vector2(20,727), self)
	$Logout.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$Logout.visible = false
	create_texture("user://Logout.png", $Logout)


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
	var theme = load("res://Themes/ButtonTheme.tres")
	create_item("UsernameLabel", Label, Vector2(175,300), $LoginSystem)
	$LoginSystem/UsernameLabel.text = "Username:"
	$LoginSystem/UsernameLabel.self_modulate = Color.black
	create_item("UsernameField", LineEdit, Vector2(100,320), $LoginSystem, Vector2(250,10))
	$LoginSystem/UsernameField.placeholder_text = "Username"
	$LoginSystem/UsernameField.set_theme(theme)
	$LoginSystem/UsernameField.grab_focus()
	$LoginSystem/UsernameField.caret_blink = true
	create_item("PasswordLabel", Label, Vector2(175,380), $LoginSystem)
	$LoginSystem/PasswordLabel.text = "Password:"
	$LoginSystem/PasswordLabel.self_modulate = Color.black
	create_item("PasswordField", LineEdit, Vector2(100,400), $LoginSystem, Vector2(250,10))
	$LoginSystem/PasswordField.placeholder_text = "Password"
	$LoginSystem/PasswordField.secret = true
	$LoginSystem/PasswordField.set_theme(theme)
	$LoginSystem/PasswordField.caret_blink = true


func log_reg_buttons():
	var theme = load("res://Themes/ButtonTheme.tres")
	create_item("LoginButton", Button, Vector2(100,445), $LoginSystem, Vector2(80,10))
	$LoginSystem/LoginButton.text = "Login"
	$LoginSystem/LoginButton.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$LoginSystem/LoginButton.set_theme(theme)
	create_item("RegisterButton", Button, Vector2(270,445), $LoginSystem, Vector2(80,10))
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
	create_texture("user://Background01.png", $BG)
	$BG.self_modulate = Color.gray
	create_item("BG2", TextureRect,Vector2(0,0), self)
	create_texture("user://Background02.png", $BG2)
	$BG2.self_modulate = "8ac2ff"


func add_recipe_button():
	var theme = load("res://Themes/ButtonTheme.tres")
	create_item("AddRecipe", Button, Vector2(205,707), self, Vector2(40,20))
	$AddRecipe.text = "+"
	$AddRecipe.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$AddRecipe.set_theme(theme)
	$AddRecipe.visible = false


func create_item_list():
	create_item("RecipeList", ItemList, Vector2(), self)
	var theme = load("res://Themes/ButtonTheme.tres")
	yield(get_tree().create_timer(0.2),"timeout")
	$Recipelist.set_theme(theme)


func recipe_addition_window():
	if has_node("./AddRecipeWindow"):
		$AddRecipeWindow.queue_free()
	yield(get_tree().create_timer(0.05),"timeout")
	create_item("AddRecipeWindow", WindowDialog, Vector2(100,250), self, Vector2(250,500))
	$AddRecipeWindow.window_title = "Add A Recipe"
	var theme = load("res://Themes/ButtonTheme.tres")
	$AddRecipeWindow.set_theme(theme)
	$AddRecipeWindow.show()
	
	create_item("Directorylabel", Label, Vector2(50,80), $AddRecipeWindow)
	$AddRecipeWindow/Directorylabel.text = "Image Location"
	
	create_item("ImageDirectory", LineEdit, Vector2(10,100), $AddRecipeWindow, Vector2(180,10))
	$AddRecipeWindow/ImageDirectory.placeholder_text = "image directory..."
	$AddRecipeWindow/ImageDirectory.editable = false
	
	create_item("BrowseButton", Button, Vector2(200,100), $AddRecipeWindow, Vector2(40,10))
	$AddRecipeWindow/BrowseButton.connect("pressed", self, "_on_browse_pressed")
	$AddRecipeWindow/BrowseButton.text = "..."
	$AddRecipeWindow/BrowseButton.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	
	create_item("Recipelabel", Label, Vector2(50,150), $AddRecipeWindow)
	$AddRecipeWindow/Recipelabel.text = "Recipe Name"
	
	create_item("RecipeName", LineEdit, Vector2(10,170), $AddRecipeWindow, Vector2(180,10))
	$AddRecipeWindow/RecipeName.placeholder_text = "Recipe Name"
	$AddRecipeWindow/RecipeName.caret_blink = true
	
	create_item("RecipeSteps", TextEdit, Vector2(10,220), $AddRecipeWindow, Vector2(230,200))
	$AddRecipeWindow/RecipeSteps.text = "Instructions/Steps"
	$AddRecipeWindow/RecipeSteps.caret_blink = true
	$AddRecipeWindow/RecipeSteps.wrap_enabled = true
	
	create_item("CancelButton", Button, Vector2(10,450), $AddRecipeWindow, Vector2(80,10))
	$AddRecipeWindow/CancelButton.connect("pressed", self, "_on_cancel_pressed")
	$AddRecipeWindow/CancelButton.text = "Cancel"
	$AddRecipeWindow/CancelButton.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	
	create_item("SaveButton", Button, Vector2(160,450), $AddRecipeWindow, Vector2(80,10))
	$AddRecipeWindow/SaveButton.connect("pressed", self, "_on_save_pressed")
	$AddRecipeWindow/SaveButton.text = "Save"
	$AddRecipeWindow/SaveButton.mouse_default_cursor_shape = CURSOR_POINTING_HAND


####### REUSABLE #######

func create_texture(path: String, obj):
	var img = Image.new()
	img.load(path)
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	if "texture" in obj:
		obj.set_texture(tex)
	else:
		obj.texture_normal = tex


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
			$AddRecipe.visible = true
			print(user_index)
			
			if File.new().file_exists("user://%s_recipe.rec" %current_user):
				load_recipe()
				setup_recipes()
			
			if File.new().file_exists("user://data.dat"):
				print(user_index <= data.FavColour.size()-1)
				if user_index <= data.FavColour.size()-1:
					print("in range")
					
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


func _on_add_recipe_pressed():
	recipe_addition_window()
	print("Add Recipe")


func _on_recipe_activated(idx):
	print("recipe activated")


func _on_cancel_pressed():
	$AddRecipeWindow.queue_free()


func _on_save_pressed():
	print("saving...")


func _on_browse_pressed():
	print("browsing files")



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
	recipe = parse_json(f.get_as_text())
	f.close()


func setup_recipes():
	if has_node("./RecipeList"):
		print("RecipeContainer already exists")
		
	else:
		create_item("RecipeList", ItemList, Vector2(100,250), self, Vector2(250,450))
		var theme = load("res://Themes/ButtonTheme.tres")
		$RecipeList.theme = theme
		$RecipeList.fixed_icon_size = Vector2(64,64)
		$RecipeList.connect("item_activated", self, "_on_recipe_activated")
		
	$RecipeList.clear()
	var i = 0
	while i <= recipe.Name.size()-1:
		var img = Image.new()
		print("i = %s"%i)
		img.load(recipe.FoodImage[i])
		var tex = ImageTexture.new()
		tex.create_from_image(img)
		$RecipeList.add_item(recipe.Name[i], tex)
		i+=1








