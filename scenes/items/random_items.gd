extends Resource
class_name RandomItems



var normal_items : Array[Item] =[
	Item.new("Potato Chip", "Salty, crisp, goodness", [Effect.new("health",10,0)],0),
	Item.new("Skullington","This skull is looking for his dad!", [Modifier.new("jump",-10),Modifier.new("speed",10)],3),
	Item.new("Tooth or Horn or Something","You're not quite sure what it is, but it's sharp!",[Modifier.new("damage",1)],4),
]

var rare_items : Array[Item] = [
	Item.new("Bobby","Won't someone be his friend?", [Modifier.new("speed",50),Modifier.new("damage",1.25)],1),
	Item.new("Bread Person", "What is up with this mysterious, sentient bread?",[Modifier.new("max_health",25)],2),
]

var epic_items : Array[Item] = [
	
]


const items: Array[Dictionary] = [
	#{"name": "Potato Chip", "description": "Salty, crispy, goodness."},
	
	#{"name": "Bobby", "description": "Won't someone be his friend?"},
	
	#{"name": "Bread Person", "description": "What is up with this mysterious, sentient bread?"}, 
	#{"name": "Skullington", "description": "This skull is looking for his dad!"},
	#{"name": "Tooth or Horn or Something", "description": "You're not quite sure what it is, but it's sharp!"},
	{"name": "Coin", "description": "A coin saved is a coin earned!"},
	{"name": "Heart", "description": "Get this back inside your body!"},
	{"name": "Sad Picture", "description": "Don't look at it too long, or you might start crying."},
	{"name": "Drop of Blood", "description": "What happens when you drink it?"},
	{"name": "Funshroom", "description": "Eating this mushroom will make you see the world differently!"},
	{"name": "Spotshroom", "description": "They say a mean, old dog is looking for these!"},
	{"name": "Key", "description": "This opens a locked something-or-other!"},
	{"name": "Giant Coffee Bean", "description": "Did you know that coffee beans are fruits?"},
	{"name": "Old Tin Can", "description": "Kick that thing!"},
	{"name": "Grandma's Ring", "description": "She's been looking all over for that!"},
	{"name": "Glass of Milk", "description": "Whether it's half empty or half full, this glass has milk in it."},
	{"name": "Feather", "description": "At least, it's supposed to be a feather."},
	{"name": "Leaf", "description": "Where did it come from?"},
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
