extends Node

static func p(tag:String, args:Array=[]):
	print("[", tag, "] ", " ".join(args.map(func(a): return str(a))))
#EOF
