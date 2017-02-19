package actors;
import sdg.Object;
import kha.Image;
import sdg.atlas.Atlas;
import sdg.graphics.Sprite;
import sdg.atlas.Region;
import sdg.components.Motion;
import sdg.components.Animator;
import sdg.components.EventDispatcher;
import sdg.collision.Hitbox;
import events.DeathEvent;

class Actor extends Object implements TwoD
{
	public static var actors:Array<Actor> = [];
	public var dmg:Int = 1;
	public var health:Int = 2;
	var speed:Float;
	var sprite:Sprite;	
	var motion:Motion;
	var animator:Animator;
	var body:Hitbox;
	var deaths:Int = 0;

	var j:Int = 0;
	public function new(x:Float, y:Float,i:Image,w:Int,h:Int)
	{
		super(x, y);

		var regions = Atlas.createRegionList(i, w, h);
		
		sprite = new Sprite(regions[0]);
		graphic = sprite;
		setSizeAuto();

		body = new Hitbox(this, null, 'collision');
		
		setupAnimations(regions);
		
		motion = new Motion();
		motion.drag.x = 0.5;
		motion.drag.y = 0.5;
		motion.maxVelocity.x = 3;
		motion.maxVelocity.y = 3;
		addComponent(motion);

		addComponent(new EventDispatcher());
		actors.push(this);
		
	}

	public override function initComponents()
	{
		super.initComponents();

		eventDispatcher.addEvent('dead',reactToDeath);
	}

	public function reactToDeath(e:DeathEvent)
	{
		if(e.origin == this)
		{
			screen.remove(this, true);
		}
		else
		{
 			deaths++;
			if(deaths == 3)
			{
  				health = 5;
				trace('FOR HIS HIGHNESS!');
			}
		}
	}

	function setupAnimations(regions:Array<Region>)
	{
		animator = new Animator();
		animator.addAnimation('idle', [regions[0]]);
		animator.addAnimation('run', regions.slice(0, 2), 5);
		animator.addAnimation('attack', [regions[2],regions[0]], 5);

		addComponent(animator);

		animator.play('idle');
	}
	
	public override function moveCollideX(object:Object):Bool
	{
		motion.velocity.x = 0;
		return true;
	}
	
	public override function moveCollideY(object:Object):Bool
	{
		motion.velocity.y = 0;
		return true;
	}	
	
	public override function update()
	{
		if(health <= 0)
		{
			eventDispatcher.dispatchEvent('dead', new DeathEvent(this));
		}
		super.update();
	}

	private function move()
	{
		if(Math.abs(motion.acceleration.y) > 0 && Math.abs(motion.acceleration.x) > 0)
		{
			motion.acceleration.y *= Math.sqrt(2);
			motion.acceleration.x *= Math.sqrt(2);
		}

		body.moveBy(motion.velocity.x, motion.velocity.y, 'collision');
	}

	public override function destroy()
	{
		super.destroy();
		active = false;
		body.destroy();
		actors.remove(this);
	}
}

