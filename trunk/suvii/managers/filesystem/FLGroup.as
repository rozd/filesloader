import inhul.managers.filesystem.events.FileEvent;import inhul.managers.filesystem.events.GroupEvent;import inhul.managers.filesystem.FLFile;import pirrest.events.Event;import pirrest.events.EventDispatcher;import pirrest.events.IEventDispatcher;import pirrest.utils.Delegate;/** * Event managers.filesystem.events.GroupEvent.FILE_ADD */[Event(GroupEvent.FILE_ADD)]/** * @author sas * @description * @version 1.0 */class inhul.managers.filesystem.FLGroup implements IEventDispatcher{	public static var $version:Number = 1.0;	public static var $className:String = "inhul.managers.filesystem.FLGroup";	public static var STATUS_READY:String = "ready";	public static var STATUS_LOAD:String = "load";	public static var STATUS_COMPLETE:String = "complete";	private static var quantity:Number = 0;	public var status:String;	public var priority:Number;	public var isLoaded:Boolean;	private var files:Array;	private var index:Number;	private var _id:Object;	function FLGroup() {		super();		EventDispatcher.initialize(this);		this.files = [];		this.index = 0;		this.isLoaded = false;		this.status = STATUS_READY;		this.id = quantity++;	}	//-----------------------------Main methods--------------------------------	public function addFile(file:FLFile):Boolean {		trace("DVK> FLGroup :: addFile ("+arguments+")");		for(var i:Number=0; i<this.files.length; i++){			if(this.files[i] == file){				return false;			}		}		//file.id = this.files.length;		this.files.push(file);		this.dispatchEvent(new GroupEvent(GroupEvent.FILE_ADD, this, file));		return true;	}	public function removeFile(file:FLFile):Boolean {		trace("DVK> FLGroup :: removeFile ("+arguments+")");		for(var i:Number=0; i<this.files.length; i++){			if(this.files[i] == file){				this.files.split(i, 1);				this.dispatchEvent(new GroupEvent(GroupEvent.FILE_REMOVE, this, file));				return true;			}		}		return false;	}	public function load():Void {		trace("DVK> FLGroup :: load ("+arguments+")");		if(this.index == this.files.length){			this.isLoaded = true;			this.status = STATUS_COMPLETE;			this.dispatchEvent(new GroupEvent(GroupEvent.LOAD_COMPLETE, this));			return;		}		this.status = STATUS_LOAD;		var file:FLFile = FLFile(this.files[this.index]);		file.addEventListener(FileEvent.LOAD_COMPLETE, Delegate.create(this, fileCompleteHandler));		file.load();	}	public function close():Void {		trace("DVK> FLGroup :: close ("+arguments+")");		if(this.status != STATUS_LOAD){			return;		}		this.status = STATUS_READY;		var file:FLFile = FLFile(this.files[this.index]);		file.close();	}	public function getFileByIndex(index):FLFile {		return this.files[index];	}	public function set id($id:Object):Void {		_id = $id;	}	public function get id():Object {		return _id;	}	public function toString():String {		return "[object FLGroup id: "+this.id+" priority: "+this.priority+"]";	}	//-----------------------------Main methods--------------------------------	//-----------------------------Handlers------------------------------------	private function fileCompleteHandler(event:FileEvent):Void {		trace("DVK> FLGroup :: fileCompleteHandler ("+arguments+")");		this.index++;		this.load();	}	//-----------------------------Handlers------------------------------------	//-----------------------------User interaction----------------------------	//-----------------------------User interaction----------------------------	//-----------------------------Event dispatcher----------------------------	public function addEventListener($type:String, $handler:Function):Boolean {return null;}	public function removeEventListener($type:String, $handler:Function):Boolean {return null;}	public function dispatchEvent($event:Event):Void {}	//-----------------------------Event dispatcher----------------------------}