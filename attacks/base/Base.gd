extends KinematicBody2D

# The word that is required to be typed
export var word_source: String = ""

# The index of the current letter needed to finish this word
var word_progress_iter: int = 0

# The letters that have been typed on this word
var word_progress_repr: String = ""

# The main formatter for the word. Use this to style how typed words
# appear using BBCode formatting tags
var format_word = "[color=blue]{progress}[/color][color=red]{remaining}[/color]"

# centers text horizontally
func format_center(text: String) -> String:
    return "[center]" + text + "[/center]"

# formats text with the progress typed
func format_with_progress(text: String, progress: String) -> String:
    var remaining = text.trim_prefix(progress)

    return format_word.format({
        "progress": progress,
        "remaining": remaining
       })

# checks an optional input 
func update_word(check_input: String = "") -> void:
    # skip if the current input is blank,
    #      if the word is blank,
    #      if word has already been typed fully (should be handled already),
    #      or if check_input is not the required letter to progress
    if check_input == "" \
        or word_source == "" \
        or word_progress_iter >= word_source.length() \
        or word_source[word_progress_iter] != check_input:
        return
    
    # increment iter and update progress string
    word_progress_iter += 1
    word_progress_repr += check_input
    
    # finally, render the word with the updated progress
    render_word()
    
    if word_progress_iter == word_source.length():
        on_complete()
        

# format and render a given word
func render_word() -> void:
    var word_text : RichTextLabel = $WordText
    word_text.bbcode_text = format_center(
        format_with_progress(word_source, word_progress_repr)
    )
    
    var word_collision : CollisionShape2D = $HitBox
    
    var bbcode_hitbox_shape := RectangleShape2D.new()
    bbcode_hitbox_shape.extents.x = word_text.get_size().x / 2
    bbcode_hitbox_shape.extents.y = word_text.get_size().y / 2
    word_collision.set_shape(bbcode_hitbox_shape)


func on_complete() -> void:
    hide()
    queue_free()
    

# updates the word with the text provided to it in the editor (if any)
func _ready() -> void:
    render_word()

# takes input from the keyboard and checks if the letter pressed was
# required to progress the word towards completion
func _input(event) -> void:
    if event is InputEventKey and event.pressed:
        # check if the currently typed character can progress this word
        update_word(char(event.unicode))
