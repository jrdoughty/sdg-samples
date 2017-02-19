package events;
import sdg.event.EventObject;
import sdg.Object;

class DeathEvent extends EventObject
{
	public var origin:Object;
	public function new(originalObject:Object) 
	{
		origin = originalObject;
		super(true);
	}
}
