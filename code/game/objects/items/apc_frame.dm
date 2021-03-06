// APC HULL

/obj/item/apc_frame
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"
	flags = CONDUCT

/obj/item/apc_frame/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), 2 )
		qdel(src)

/obj/item/apc_frame/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in cardinal))
		return
	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		usr << "<span class='alert'>APC cannot be placed on this spot.</span>"
		return
	if (A.requires_power == 0 || istype(A, /area/space))
		usr << "<span class='alert'>APC cannot be placed in this area.</span>"
		return
	var/list/apc = A.get_apc()
	var/apc_len = apc.len
	if (apc_len > 0)
		usr << "<span class='alert'>This area already has APC.</span>"
		return //only one APC per area
	for(var/obj/machinery/power/terminal/T in loc)
		if (T.master)
			usr << "<span class='alert'>There is another network terminal here.</span>"
			return
		else
			var/obj/item/stack/cable_coil/C = new /obj/item/stack/cable_coil(loc)
			C.amount = 10
			usr << "You cut the cables and disassemble the unused power terminal."
			qdel(T)
	new /obj/machinery/power/apc(loc, ndir, 1)
	qdel(src)
