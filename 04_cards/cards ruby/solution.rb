module HandFactory
  def get_hand(deck_name, *args)
    return WarHand.new(*args) if deck_name == 'WarDeck'
    return BeloteHand.new(*args) if deck_name == 'BeloteDeck'
    return SixtySixHand.new(*args) if deck_name == 'SixtySixDeck'
  end
end

class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    return "#{@rank.to_s.capitalize} of #{@suit.to_s.capitalize}"
  end
end

class Deck
  include Enumerable
  include HandFactory

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  SUITS = [:spades, :hearts, :diamonds, :clubs]

  def initialize(cards = nil)
    @cards = cards || self.class::RANKS.product(SUITS)
      .map { |card_parameters| Card.new(card_parameters[0],card_parameters[1]) }
  end

  def each(&block)
    @cards.each { |rank| block.call(rank) }
  end

  def size
    size = self.class::RANKS.length * SUITS.length
  end

  def draw_top_card
    top_card = @cards.shift
  end

  def draw_bottom_card
    bottom_card = @cards.shift
  end

  def top_card
    top_card = @cards[0]
  end

  def bottom_card
    bottom_card = @cards[-1]
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort! do |a, b|
      rank_sort = RANKS.index(b.rank) <=> RANKS.index(a.rank)
      rank_sort.zero? ? SUITS.index(a.suit) <=> SUITS.index(b.suit) : rank_sort
    end
  end

  def deal
    cards = @cards.shift(@cards_to_deal)
    #hand = get_hand(self.class.name, cards)
    hand = self.class.get_hand(cards)
  end

  def to_s
    @cards.each(&:to_s)
  end
end

class WarDeck < Deck
  attr_reader :cards_to_deal

  def initialize(cards = nil)
    super
    @cards_to_deal = 26
  end
end

class BeloteDeck < Deck
  RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]
  def initialize(cards = nil)
    super
    @cards_to_deal = 8
  end
end

class SixtySixDeck < Deck
  RANKS = [ 9, :jack, :queen, :king, 10, :ace]
  def initialize(cards = nil)
    super
    @cards_to_deal = 6
  end
end

class Hand
  def initialize(cards)
    @cards = cards
  end

  def size
    @cards.length
  end
end

class WarHand < Hand
  FACE_UP_LIMIT = 3

  def play_card
    @cards.shift
  end

  def allow_face_up?
    @cards.length <= FACE_UP_LIMIT
  end
end

class BeloteHand < Hand
	def self.get_hand(cards)
		self.new(...)
	end

  def highest_of_suit(suit)
    @cards.select { |card| card.suit == suit}
    .sort { |a, b| b.rank  <=> a.rank }
    .first
  end

  def belote?
    res = @cards.select { |card| card.rank == :queen or card.rank == :king }
    .group_by { |card| card.suit }
    .any? { |group| group[1].length == 2}
  end

  def tierce?
    has_consecutive(3)
  end

  def quarte?
    has_consecutive(4)
  end

  def quint?
    has_consecutive(5)
  end

  def carre_of_jacks?
    has_carre_of(:jack)
  end

  def carre_of_nines?
    has_carre_of(9)
  end

  def carre_of_aces?
    has_carre_of(:ace)
  end

  private

  def sort_by_rank(cards)
    sorted_cards = cards.sort_by do |card|
      [ BeloteDeck::SUITS.index(card.suit), BeloteDeck::RANKS.index(card.rank)]
    end
  end

  def has_consecutive(n)
    ranks, sorted_cards = BeloteDeck::RANKS, sort_by_rank(@cards)

    sorted_cards.slice_when do |current, next_card|
      ranks.index(current.rank) + 1 != ranks.index(next_card.rank)
    end.any? { |sequence| sequence.length == n }
  end

  def has_carre_of(rank)
    cards_of_rank = @cards.select do |card|
      card.rank == rank
    end

    has_carre = cards_of_rank.length == 4
  end
end

class SixtySixHand < Hand
  def initialize(cards)
    @cards = cards
  end

  def twenty?(trump_suit)
    get_couples_by_suit.any? do |group|
      group[1].length == 2 and group[0] != trump_suit
    end
  end

  def forty?(trump_suit)
    get_couples_by_suit.any? do |group|
      group[1].length == 2 and group[0] == trump_suit
    end
  end

  private

  def get_couples_by_suit
    couples = @cards.select { |card| card.rank == :queen or card.rank == :king }
    .group_by { |card| card.suit }
  end
end



      deck = SixtySixDeck.new([Card.new(7, :spades),Card.new(:queen, :diamonds),Card.new(:jack, :heartd),Card.new(:jack, :clubs),Card.new(:queen, :spades)])
      deck.shuffle
      hand = deck.deal
      p hand.forty?(:diamonds)