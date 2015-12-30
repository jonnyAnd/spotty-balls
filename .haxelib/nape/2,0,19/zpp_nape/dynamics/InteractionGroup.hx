package zpp_nape.dynamics;
import zpp_nape.Const;
import zpp_nape.ID;
import zpp_nape.constraint.PivotJoint;
import zpp_nape.constraint.Constraint;
import zpp_nape.constraint.WeldJoint;
import zpp_nape.constraint.DistanceJoint;
import zpp_nape.constraint.UserConstraint;
import zpp_nape.constraint.LineJoint;
import zpp_nape.constraint.LinearJoint;
import zpp_nape.constraint.MotorJoint;
import zpp_nape.constraint.AngleJoint;
import zpp_nape.phys.Interactor;
import zpp_nape.phys.FeatureMix;
import zpp_nape.phys.Material;
import zpp_nape.constraint.PulleyJoint;
import zpp_nape.phys.FluidProperties;
import zpp_nape.phys.Compound;
import zpp_nape.callbacks.OptionType;
import zpp_nape.callbacks.CbSetPair;
import zpp_nape.callbacks.CbType;
import zpp_nape.phys.Body;
import zpp_nape.callbacks.CbSet;
import zpp_nape.callbacks.Callback;
import zpp_nape.geom.GeomPoly;
import zpp_nape.callbacks.Listener;
import zpp_nape.geom.Mat23;
import zpp_nape.geom.ConvexRayResult;
import zpp_nape.geom.Cutter;
import zpp_nape.geom.Ray;
import zpp_nape.geom.Vec2;
import zpp_nape.geom.Convex;
import zpp_nape.geom.MatMath;
import zpp_nape.geom.PartitionedPoly;
import zpp_nape.geom.Triangular;
import zpp_nape.geom.Simplify;
import zpp_nape.geom.AABB;
import zpp_nape.geom.SweepDistance;
import zpp_nape.geom.Simple;
import zpp_nape.geom.Monotone;
import zpp_nape.geom.VecMath;
import zpp_nape.geom.Vec3;
import zpp_nape.geom.MatMN;
import zpp_nape.geom.PolyIter;
import zpp_nape.geom.MarchingSquares;
import zpp_nape.geom.Geom;
import zpp_nape.shape.Circle;
import zpp_nape.geom.Collide;
import zpp_nape.shape.Shape;
import zpp_nape.shape.Edge;
import zpp_nape.space.Broadphase;
import zpp_nape.shape.Polygon;
import zpp_nape.space.SweepPhase;
import zpp_nape.space.DynAABBPhase;
import zpp_nape.dynamics.Contact;
import zpp_nape.space.Space;
import zpp_nape.dynamics.InteractionFilter;
import zpp_nape.dynamics.SpaceArbiterList;
import zpp_nape.dynamics.Arbiter;
import zpp_nape.util.Array2;
import zpp_nape.util.Lists;
import zpp_nape.util.Flags;
import zpp_nape.util.Queue;
import zpp_nape.util.Debug;
import zpp_nape.util.RBTree;
import zpp_nape.util.FastHash;
import zpp_nape.util.Pool;
import zpp_nape.util.Names;
import zpp_nape.util.Circular;
import zpp_nape.util.WrapLists;
import zpp_nape.util.UserData;
import zpp_nape.util.Math;
import nape.TArray;
import zpp_nape.util.DisjointSetForest;
import nape.Config;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.constraint.Constraint;
import nape.constraint.UserConstraint;
import nape.constraint.DistanceJoint;
import nape.constraint.LineJoint;
import nape.constraint.LinearJoint;
import nape.constraint.ConstraintList;
import nape.constraint.AngleJoint;
import nape.constraint.MotorJoint;
import nape.constraint.ConstraintIterator;
import nape.phys.GravMassMode;
import nape.phys.BodyList;
import nape.phys.Interactor;
import nape.phys.InertiaMode;
import nape.phys.InteractorList;
import nape.constraint.PulleyJoint;
import nape.phys.MassMode;
import nape.phys.Material;
import nape.phys.InteractorIterator;
import nape.phys.FluidProperties;
import nape.phys.BodyIterator;
import nape.phys.Compound;
import nape.phys.CompoundList;
import nape.phys.BodyType;
import nape.phys.CompoundIterator;
import nape.callbacks.InteractionListener;
import nape.callbacks.OptionType;
import nape.callbacks.PreListener;
import nape.callbacks.BodyListener;
import nape.callbacks.ListenerIterator;
import nape.callbacks.CbType;
import nape.callbacks.ListenerType;
import nape.callbacks.PreFlag;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import nape.callbacks.PreCallback;
import nape.callbacks.InteractionCallback;
import nape.callbacks.ListenerList;
import nape.callbacks.ConstraintListener;
import nape.callbacks.BodyCallback;
import nape.callbacks.CbTypeList;
import nape.callbacks.Callback;
import nape.phys.Body;
import nape.callbacks.CbTypeIterator;
import nape.callbacks.ConstraintCallback;
import nape.callbacks.Listener;
import nape.geom.Mat23;
import nape.geom.ConvexResultIterator;
import nape.geom.Ray;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyIterator;
import nape.geom.Vec2Iterator;
import nape.geom.RayResult;
import nape.geom.Winding;
import nape.geom.Vec2List;
import nape.geom.RayResultIterator;
import nape.geom.AABB;
import nape.geom.IsoFunction;
import nape.geom.GeomVertexIterator;
import nape.geom.ConvexResult;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;
import nape.geom.RayResultList;
import nape.geom.Vec3;
import nape.geom.MatMN;
import nape.geom.ConvexResultList;
import nape.geom.MarchingSquares;
import nape.shape.Circle;
import nape.shape.ValidationResult;
import nape.geom.Geom;
import nape.shape.ShapeIterator;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.shape.Edge;
import nape.shape.EdgeList;
import nape.shape.ShapeList;
import nape.shape.EdgeIterator;
import nape.shape.ShapeType;
import nape.space.Broadphase;
import nape.dynamics.Contact;
import nape.dynamics.InteractionGroupList;
import nape.dynamics.Arbiter;
import nape.dynamics.InteractionGroup;
import nape.space.Space;
import nape.dynamics.ContactIterator;
import nape.dynamics.ArbiterList;
import nape.dynamics.InteractionFilter;
import nape.dynamics.ArbiterIterator;
import nape.dynamics.InteractionGroupIterator;
import nape.dynamics.FluidArbiter;
import nape.dynamics.ContactList;
import nape.dynamics.CollisionArbiter;
import nape.dynamics.ArbiterType;
import nape.util.Debug;
import nape.util.BitmapDebug;
import nape.util.ShapeDebug;
#if nape_swc@:keep #end
class ZPP_InteractionGroup{
    public var outer:InteractionGroup=null;
    public var ignore:Bool=false;
    public var group:ZPP_InteractionGroup=null;
    public function setGroup(group:ZPP_InteractionGroup){
        if(this.group!=group){
            if(this.group!=null){
                this.group.remGroup(this);
                this.group.invalidate(true);
            }
            this.group=group;
            if(group!=null){
                group.addGroup(this);
                group.invalidate(true);
            }
            else this.invalidate(true);
        }
    }
    public var groups:ZNPList_ZPP_InteractionGroup=null;
    public var wrap_groups:InteractionGroupList=null;
    public var interactors:ZNPList_ZPP_Interactor=null;
    public var wrap_interactors:InteractorList=null;
    public var depth:Int=0;
    public function invalidate(force=false){
        if(!(force||ignore))return;
        {
            var cx_ite=interactors.begin();
            while(cx_ite!=null){
                var b=cx_ite.elem();
                {
                    if(b.isBody())b.ibody.wake();
                    else if(b.isShape())b.ishape.body.wake();
                    else b.icompound.wake();
                };
                cx_ite=cx_ite.next;
            }
        };
        {
            var cx_ite=groups.begin();
            while(cx_ite!=null){
                var g=cx_ite.elem();
                g.invalidate(force);
                cx_ite=cx_ite.next;
            }
        };
    }
    public static var SHAPE=1;
    public static var BODY=2;
    public function new(){
        depth=0;
        groups=new ZNPList_ZPP_InteractionGroup();
        interactors=new ZNPList_ZPP_Interactor();
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function addGroup(group:ZPP_InteractionGroup){
        groups.add(group);
        group.depth=depth+1;
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function remGroup(group:ZPP_InteractionGroup){
        groups.remove(group);
        group.depth=0;
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function addInteractor(intx:ZPP_Interactor){
        interactors.add(intx);
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function remInteractor(intx:ZPP_Interactor,flag:Int=-1){
        interactors.remove(intx);
    }
}
