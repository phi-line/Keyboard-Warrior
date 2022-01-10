extends Node2D

# json file to infer the level from
export var level_path: String

# Word attack to spawn at scheduled intervals
var Word := preload("res://attacks/bouncy/Bouncy.tscn")

# local state for the words to spawn
var attack_sequence := []

# load a json file as dict
func load_json_file(path: String) -> Dictionary:
    var file := File.new()
    var _open_file = file.open(path, file.READ)
    var text = file.get_as_text()
    var result_json = JSON.parse(text)
    if result_json.error != OK:
        print("Error while loading json from file:")
        print("\tL", result_json.error_line, ": ", result_json.error)
        print("\t", result_json.error_string)
        return {}
    var obj = result_json.result
    return obj

# load the level from file and populate the local state
func load_level(path: String) -> void:
    # infer the level from the json
    var level := load_json_file(path)
    
    # abort program if level could not be loaded (check console for error)
    if level == {}:
        get_tree().quit()
    
    # populate the attack sequence for the boss
    attack_sequence = level["attackSequence"]

# once the start timer finishes, we can begin spawning words
# start timer might be replaced with an animation reel to
# allow for a pre-level cutscene
func _on_StartTimer_timeout() -> void:
    print("starting wave...")
    var SpawnTimer : Timer = $SpawnTimer
    SpawnTimer.start()
    # Start the first wave manually since timer does not trigger on 0
    _on_SpawnTimer_timeout()

# spawn a word every interval
func _on_SpawnTimer_timeout() -> void:
    var word_source = attack_sequence.pop_front()
    print("spawning word: ", word_source)
    
    # choose a random location on Path 2D
    var WordSpawnLocation : PathFollow2D = $WordPath/WordSpawnLocation
    WordSpawnLocation.offset = randi()
    
    # create a Word instance with the next sequence and add it to the scene
    var word = Word.instance()
    word.word_source = word_source
    add_child(word)
    
    # set the mob's position to the center
    word.position = Vector2(400, 300)
    
    # calculate the mob's direction perpendicular to the path direction.
    # randomize it to create an angle 
    var direction = WordSpawnLocation.rotation + PI / 2
    direction += rand_range(-PI / 4, PI / 4)
    
    # set the velocity for speed and direction
    word.velocity = Vector2(rand_range(word.min_speed, word.max_speed), 0)
    word.velocity = word.velocity.rotated(direction)
    
    # stop if there are no more words
    if attack_sequence.size() == 0:
        var SpawnTimer : Timer = $SpawnTimer
        SpawnTimer.stop()

# prepare the level from file and initialize all timers
func _ready() -> void:
    randomize()
    load_level(level_path)
    var SpawnTimer : Timer = $SpawnTimer
    SpawnTimer.start()
