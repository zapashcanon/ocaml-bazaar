(**************************************************************************)
(*                                                                        *)
(*  Copyright (C) Jean-Christophe Filliatre                               *)
(*                                                                        *)
(*  This software is free software; you can redistribute it and/or        *)
(*  modify it under the terms of the GNU Library General Public           *)
(*  License version 2.1, with the special exception on linking            *)
(*  described in file LICENSE.                                            *)
(*                                                                        *)
(*  This software is distributed in the hope that it will be useful,      *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  *)
(*                                                                        *)
(**************************************************************************)

(** Bags (aka multisets).

    A bag is merely a map that binds each element to its multiplicity
    in the bag (see function [occ] below).
*)

module Make(X: sig

  type t

  val compare: t -> t -> int
  (** Bags are implemented using [Map.Make] and therefore require elements
      to be comparable. *)

  val hash: t -> int
  (** This is not required by the bag implementation. It is only required
      if you indeed to use function [hash] below e.g. to use bags as
      hash table keys. *)

end) : sig

  type elt = X.t

  type t
  (** The immutable type of bags. *)

  val empty: t
  (** The empty bag. *)

  val is_empty: t -> bool
  (** Test for emptiness. *)

  val add: elt -> ?mult:int -> t -> t
  (** [add x ?mult b] returns a new bag where the multiplicity of [x]
      is increased by [mult] (defaults to one).
      Raises [Invalid_argument] is [mult] is negative.*)

  val singleton: elt -> t
  (** [singleton x] is a bag with one element [x], with multiplicity [1]. *)

  val remove: elt -> ?mult:int -> t -> t
  (** [remove x ?mult b] returns a new bag where the multiplicity of [x]
      is decreased by [mult] (defaults to one).
      Raises [Invalid_argument] is [mult] is negative.*)

  val occ: elt -> t -> int
  (** [occ x b] is the number of occurrences of [x] in bag [b].
       It returns 0 when [x] is not in [b]. *)

  val mem: elt -> t -> bool
  (** [mem x b] checks whether [x] belongs to [b], i.e. has a multiplicty
      greater than 0. *)

  val cardinal: t -> int
  (** [cardinal b] is the sum of the multiplicities. *)

  val union : t -> t -> t
  (** [union b1 b2] returns a new bag [b] where, for all element x,
      [occ x b = max (occ x b1) (occ x b2)]. *)

  val sum: t -> t -> t
  (** [sum b1 b2] returns a new bag [b] where, for all element x,
      [occ x b = occ x b1 + occ x b2]. *)

  val inter : t -> t -> t
  (** [inter b1 b2] returns a new bag [b] where, for all element x,
      [occ x b = min (occ x b1) (occ x b2)]. *)

  val diff : t -> t -> t
  (** [diff b1 b2] returns a new bag [b] where, for all element x,
      [occ x b = max 0 (occ x b1 - occ x b2)]. *)

  val disjoint : t -> t -> bool
  (** Test if two bags are disjoint. *)

  val included: t -> t -> bool
  (** [included b1 b2] returns true if and only if, for all element x,
      [occ x b1 <= occ x b2]. *)

  val iter: (elt -> int -> unit) -> t -> unit
  (** [iter f b] applies [f] to all elements in bag [b].  [f] receives the
      element as first argument, and its multiplicity as second argument.
      The elements are  passed to [f] in increasing order with respect to
      the ordering over the type of the elements. *)

  val fold: (elt -> int -> 'a -> 'a) -> t -> 'a -> 'a
  (** [fold f b a] computes [(f xN mN ... (f x1 m1 a)...)] , where [x1 ... xN]
      are the elements in bag [b] (in increasing order), and [m1 ... mN] are
      their multiplicities. *)

  val for_all : (elt -> int -> bool) -> t -> bool
  (** [for_all p b] checks if all the elements of the bag satisfy the predicate
      [p]. *)

  val exists : (elt -> int -> bool) -> t -> bool
  (** [exists p b] checks if at least one element of the bag satisfies the
      predicate [p]. *)

  val compare: t -> t -> int
  (** Total ordering between bags. *)

  val equal: t -> t -> bool
  (** [equal b1 b2] tests whether the bags [b1] and [b2] are equal, that is,
      contain equal elements with equal multiplicities. *)

  val hash: t -> int
  (** Hash function for bags. It uses function [X.hash] to hash elements.
      This function is consistent with function [equal], so that this module
      can be passed as argument to [Hashtbl.Make]. *)

end

