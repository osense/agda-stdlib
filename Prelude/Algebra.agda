------------------------------------------------------------------------
-- Some algebraic structures
------------------------------------------------------------------------

open import Prelude.BinaryRelation

module Prelude.Algebra (s : Setoid) where

open import Prelude.Product
private
  open module S = Setoid s

------------------------------------------------------------------------
-- Operations taking one and two arguments

Op₁ : Set
Op₁ = carrier -> carrier

Op₂ : Set
Op₂ = carrier -> carrier -> carrier

------------------------------------------------------------------------
-- Properties of operations

Associative : Op₂ -> Set
Associative _•_ = forall x y z -> (x • (y • z)) ≈ ((x • y) • z)

Commutative : Op₂ -> Set
Commutative _•_ = forall x y -> (x • y) ≈ (y • x)

LeftIdentity : carrier -> Op₂ -> Set
LeftIdentity e _•_ = forall x -> (e • x) ≈ x

RightIdentity : carrier -> Op₂ -> Set
RightIdentity e _•_ = forall x -> (x • e) ≈ x

Identity : carrier -> Op₂ -> Set
Identity e • = LeftIdentity e • × RightIdentity e •

LeftZero : carrier -> Op₂ -> Set
LeftZero z _•_ = forall x -> (z • x) ≈ z

RightZero : carrier -> Op₂ -> Set
RightZero z _•_ = forall x -> (x • z) ≈ z

Zero : carrier -> Op₂ -> Set
Zero z • = LeftZero z • × RightZero z •

LeftInverse : carrier -> Op₁ -> Op₂ -> Set
LeftInverse e _⁻¹ _•_ = forall x -> (x ⁻¹ • x) ≈ e

RightInverse : carrier -> Op₁ -> Op₂ -> Set
RightInverse e _⁻¹ _•_ = forall x -> (x • (x ⁻¹)) ≈ e

Inverse : carrier -> Op₁ -> Op₂ -> Set
Inverse e ⁻¹ • = LeftInverse e ⁻¹ • × RightInverse e ⁻¹ •

_DistributesOverˡ_ : Op₂ -> Op₂ -> Set
_*_ DistributesOverˡ _+_ =
  forall x y z -> (x * (y + z)) ≈ ((x * y) + (x * z))

_DistributesOverʳ_ : Op₂ -> Op₂ -> Set
_*_ DistributesOverʳ _+_ =
  forall x y z -> ((y + z) * x) ≈ ((y * x) + (z * x))

_DistributesOver_ : Op₂ -> Op₂ -> Set
* DistributesOver + = (* DistributesOverˡ +) × (* DistributesOverʳ +)

------------------------------------------------------------------------
-- Combinations of properties (one operation)

record Semigroup (• : Op₂) : Set where
  assoc    : Associative •
  •-pres-≈ : • Preserves₂ _≈_ , _≈_ , _≈_

record Monoid (• : Op₂) (ε : carrier) : Set where
  semigroup : Semigroup •
  identity  : Identity ε •

record CommutativeMonoid (• : Op₂) (ε : carrier) : Set where
  monoid : Monoid • ε
  comm   : Commutative •

record Group (• : Op₂) (ε : carrier) (⁻¹ : Op₁) : Set where
  monoid    : Monoid • ε
  inverse   : Inverse ε ⁻¹ •
  ⁻¹-pres-≈ : ⁻¹ Preserves _≈_ , _≈_

record AbelianGroup (• : Op₂) (ε : carrier) (⁻¹ : Op₁) : Set where
  group : Group • ε ⁻¹
  comm  : Commutative •

------------------------------------------------------------------------
-- Combinations of properties (two operations)

record Semiring (+ * : Op₂) (0# 1# : carrier) : Set where
  +-monoid : CommutativeMonoid + 0#
  *-monoid : Monoid * 1#
  distrib  : * DistributesOver +
  zero     : Zero 0# *

record Ring (+ * : Op₂) (- : Op₁) (0# 1# : carrier) : Set where
  +-group  : AbelianGroup + 0# -
  *-monoid : Monoid * 1#
  distrib  : * DistributesOver +