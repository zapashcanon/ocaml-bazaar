
module I = struct include Int let hash x = x end

module B = Bag.Make(I)

let () =
  let a = B.add 1 ~mult:1 (B.add 2 ~mult:2 (B.add 3 ~mult:3 B.empty)) in
  let b = B.add 1 ~mult:4 (B.add 2 ~mult:5 (B.add 3 ~mult:6 B.empty)) in
  assert (B.cardinal a = 6);
  assert (B.cardinal (B.sum a b) = 21);
  assert (B.cardinal (B.union a b) = 15);
  assert (B.is_empty (B.diff a b));
  assert (B.cardinal (B.diff b a) = 9);
  assert (B.equal (B.inter a b) a);
  assert (B.included a b);
  assert (not (B.included b a));
  assert (not (B.disjoint b a));
  assert (B.elements a = [1,1; 2,2; 3,3]);
  assert (B.min_elt a = (1,1));
  assert (B.max_elt a = (3,3));
  let f x n = Some 1 in
  assert (B.cardinal (B.filter_map f a) = 3);
  assert (B.cardinal (B.filter_map f b) = 3);
  let e = B.filter (fun x _ -> x mod 2 = 0) a in
  assert (B.min_elt e = (2,2));
  assert (B.max_elt e = (2,2));
  assert (B.choose e = (2,2));
  assert (B.cardinal e = 2);
  let o =
    B.filter_map (fun x m -> if x mod 2 = 1 then Some (2*m) else None) b in
  assert (B.min_elt o = (1,8));
  assert (B.max_elt o = (3,12));
  assert (B.cardinal o = 20);
  ()

let test n =
  let b1 = ref B.empty in
  let b2 = ref B.empty in
  for x = 0 to n do
    b1 := B.add x ~mult:2 !b1;
    assert (B.cardinal !b1 = 2*(x+1));
    b2 := B.add (n-x) !b2;
    assert (B.cardinal !b2 = 2*x+1);
    b2 := B.add (n-x) !b2;
    if x < n/2 then assert (B.disjoint !b1 !b2)
  done;
  assert (B.mem n !b1);
  assert (B.occ n !b1 = 2);
  assert (B.cardinal !b1 = 2*(n+1));
  assert (B.cardinal !b2 = 2*(n+1));
  assert (B.equal !b1 !b2);
  assert (B.hash !b1 = B.hash !b2);
  assert (B.for_all (fun x _ -> x <= n) !b1);
  assert (not (B.for_all (fun x _ -> x < n) !b1));
  assert (B.exists (fun x m -> x = 0 && m = 2) !b2);
  for x = 0 to n do
    b1 := B.remove x !b1;
    b2 := B.remove (n-x) ~mult:2 !b2;
    b1 := B.remove x !b1;
  done;
  assert (B.is_empty !b1);
  assert (B.is_empty !b2);
  ()

let () =
  for n = 0 to 10 do test (10 * n) done

