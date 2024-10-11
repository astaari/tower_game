extends Resource
class_name RandomItems


@export var normal_weight = 10000
@export var rare_weight = 4000
@export var epic_weight = 1500

var normal_count = 0
var rare_count = 0
var epic_count = 0


func get_random_item() -> Item:
	var weight_sum = normal_weight+rare_weight+epic_weight
	var rand = randf_range(0,weight_sum)
	
	var item : Item
	if rand <=epic_weight:
		#epic
		epic_count+=1
		#print("got epic")
		item = _epic_items.pick_random()
	elif rand <= epic_weight+rare_weight:
		#print("got rare")
		rare_count+=1
		item = _rare_items.pick_random()
	else:
		#print("got normal")
		normal_count+=1
		item = _normal_items.pick_random()
	print("Normal count: ",normal_count)
	print("Rare count: ",rare_count)
	print("Epic count: ",epic_count)
	
	
	return item

var _normal_items : Array[Item] =[
	Item.new("Potato Chip", "Salty, crisp, goodness", [Effect.new("health",15,0)],0),
	Item.new("Skullington","This skull is looking for his dad!", [Modifier.new("jump",-10),Modifier.new("speed",10)],3),
	Item.new("Sharp Tooth","You're not quite sure what it is, but it's sharp!",[Modifier.new("damage",0.3)],4),
	Item.new("Heart","Get this back inside your body!",[Modifier.new("max_health",10)],6),
	Item.new("Sad Picture","Don't look at it too long, or you might start crying.",[Modifier.new("damage_resist",0.01),Modifier.new("max_health",-10)],7),
	Item.new("Key","This opens a locked something-or-other!",[Modifier.new("damage",0.1),Modifier.new("damage_resist",0.01)],11),
	Item.new("Glass of Milk","Yum",[Modifier.new("max_health",5),Modifier.new("health",10)],15),
	
	Item.new("Old Tin Can", "Kick That Thing",[Modifier.new("damage_resist",0.01)],13),
	#Item.new(),
	#Item.new(),
	#Item.new(),
	#Item.new(),
	#Item.new(),
	
	
	
]

var _rare_items : Array[Item] = [
	Item.new("Bobby","Won't someone be his friend?", [Modifier.new("speed",50),Modifier.new("damage",1.25)],1),
	Item.new("Bread Person", "What is up with this mysterious, sentient bread?",[Modifier.new("max_health",25)],2),
	Item.new("Coin","A coin saved is a coin earned!",
		[Modifier.new("speed",30),Modifier.new("damage_resist",0.03),Modifier.new("attack_speed",-0.8)],
	5),
	Item.new("Drop of Blood","What happens when you drink it?",[Modifier.new("max_health",20),Modifier.new("health",20)],8),
	Item.new("Giant Coffee Bean", "Did you know that coffee beans are fruits?",[Modifier.new("health",40)],12),
	Item.new("Grandma's Ring", "She's been looking all over for that!",[Modifier.new("character_size",-0.05),Modifier.new("attack_speed",-0.075)],14),
	Item.new("Leaf","Where did it come from?",[Modifier.new("damage",0.3),Modifier.new("attack_speed",-0.05)],17),
	#Item.new(),
	#Item.new(),
	#Item.new(),
	#Item.new(),
	#Item.new(),
	#Item.new(),
	
]

var _epic_items : Array[Item] = [
	Item.new("Funshroom","Eating this mushroom will make you see the world differently!",
		[Modifier.new("speed",40),Modifier.new("damage",0.75),Modifier.new("character_size",-0.1)],
	9),
	Item.new("Spotshroom","They say a mean, old dog is looking for these!",
		[Modifier.new("speed",40),Modifier.new("character_size",0.1)],
	10),
	Item.new("Feather","What's heavier, a kilogram of steel, or a kilogram of feathers?",
		[Modifier.new("speed",75),Modifier.new("jump_height",30),Modifier.new("attack_speed",-0.075)],
	16),
	Item.new("Divide","And conquer!",[Modifier.new("damage_resist",0.05),Modifier.new("max_health",15)]),
	#Item.new(),
	#Item.new(),
	#Item.new(),
	
]


const items: Array[Dictionary] = [
	#{"name": "Potato Chip", "description": "Salty, crispy, goodness."}, 0
	#{"name": "Bobby", "description": "Won't someone be his friend?"}, 1
	#{"name": "Bread Person", "description": "What is up with this mysterious, sentient bread?"},  2
	#{"name": "Skullington", "description": "This skull is looking for his dad!"}, 3
	#{"name": "Tooth or Horn or Something", "description": "You're not quite sure what it is, but it's sharp!"}, 4 
	#{"name": "Coin", "description": "A coin saved is a coin earned!"},5
	#{"name": "Heart", "description": "Get this back inside your body!"}, 6
	#{"name": "Sad Picture", "description": "Don't look at it too long, or you might start crying."}, 7
	#{"name": "Drop of Blood", "description": "What happens when you drink it?"},8
	#{"name": "Funshroom", "description": "Eating this mushroom will make you see the world differently!"},9
	#{"name": "Spotshroom", "description": "They say a mean, old dog is looking for these!"},10
	#{"name": "Key", "description": "This opens a locked something-or-other!"},11
	#{"name": "Giant Coffee Bean", "description": "Did you know that coffee beans are fruits?"},12
	#{"name": "Old Tin Can", "description": "Kick that thing!"},13
	#{"name": "Grandma's Ring", "description": "She's been looking all over for that!"},14
	#{"name": "Glass of Milk", "description": "Whether it's half empty or half full, this glass has milk in it."},15
	#{"name": "Feather", "description": "At least, it's supposed to be a feather."},16
	#{"name": "Leaf", "description": "Where did it come from?"},17
	{"name": "Jumpshroom", "description": "Jump on these bad boys for a good time!"},
	{"name": "Approximately", "description": "Neither here nor there, as the kids are saying these days."},
	{"name": "Divide", "description": "...and conquer!"},
	{"name": "Scary Right Hand", "description": "If this game weren't limited to two colors, you bet this hand would be red!"},
	{"name": "Just a Flower", "description": "That's all there is to this."},
	{"name": "Love Letter", "description": "Tell them how you really feel!"},
	{"name": "One of Those Jelly Filled Cookies", "description": ""},
	{"name": "Yin", "description": "Dark shit."},
	{"name": "Yang", "description": "Light shit."},
	{"name": "Maybe a Pecan", "description": "If you're allergic to nuts, then don't bother."},
	{"name": "AA Battery", "description": "Only one."},
	{"name": "Metal Sphere", "description": "Don't let Jerry choke on this."},
	{"name": "Jerry", "description": "Just leave him alone, okay?"},
	{"name": "Question", "description": "You can't know everything."},
	{"name": "F-Hole", "description": "Don't make it inappropriate."},
	{"name": "Floppy Disc", "description": "Back in my day..."},
	{"name": "Evil Spiral", "description": "Ew, would you look at that thing!?"},
	{"name": "Just Bread", "description": "I bet this will heal you."},
	{"name": "Theodore", "description": "He's a little grumpy, but it's not your fault."},
	{"name": "Cosmic Gemstone", "description": "Whatever you do, don't eat it!"},
	{"name": "Portal Key", "description": "Woah, what?!"},
	{"name": "Chess Board", "description": "...not checkers."},
	{"name": "Star", "description": "Yes, you really can own a star."},
	{"name": "Star Sticker", "description": "Good job!"},
	{"name": "Star Replica", "description": "Almost as good as the real thing."},
	{"name": "Outlet", "description": "Get some power!"},
	{"name": "Benevolent Spiral", "description": "Aw, it's so cute."},
	{"name": "Another Key", "description": "This key seems special."},
	{"name": "Portal to Another World", "description": "Where did you go?"},
	{"name": "Map", "description": "Now you know where you go!"},
	{"name": "Pooch", "description": "I don't really like dogs, so you can have this one."},
	{"name": "Disc", "description": "Maybe the dog will like it."},
	{"name": "Handheld Video Game Thingy", "description": "Retro, baby."},
	{"name": "Tortilla Chip", "description": "No salsa!?"},
	{"name": "Vengeful Left Hand", "description": "Don't tell the right hand what you're doing."},
	{"name": "Fire", "description": "This will warm you right up!"},
	{"name": "Walkie-Talkie", "description": "Are you reading me?"},
	{"name": "Stemless Leaf", "description": "They're all the rage these days."},
	{"name": "Bone", "description": "It's just a bone... or is it?"},
	{"name": "Rake", "description": "It's just a rake."},
	{"name": "Stone", "description": "It's just a rock."},
	{"name": "The Watcher from the Other Side", "description": "It will destroy you in an instance but it is the key to solving this whole thing!"},
	{"name": "Sunglasses", "description": "Cool kid."},
	{"name": "Lightbulb", "description": "Ah ha!"},
	{"name": "Ace of Spades", "description": "Slip this up your sleeve for later use."},
	{"name": "Die", "description": "Take your chances!"}
]
