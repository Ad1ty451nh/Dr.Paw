//
//  AnimalData.swift
//  Dr.Paw
//
//  Real starter data for all 17 requested animals. Review/adjust
//  wording as you like — this is meant to get the library fully
//  populated and working, not to be the final word on animal care.
//

import Foundation

enum AnimalData {
    static let all: [Animal] = [

        // MARK: Dogs
        Animal(
            name: "Labrador",
            species: "Labrador Retriever",
            category: .dog,
            imageName: "Labrador",
            idealEnvironment: "Active family home with yard space to run and swim in; not suited to being left alone for long stretches.",
            bestFood: "High-quality protein-based kibble, lean meats like chicken, occasional fruits like apples and blueberries.",
            foodToAvoid: "Chocolate, grapes/raisins, onions, garlic, xylitol (sugar-free gum), macadamia nuts.",
            specificTip: "Prone to obesity — measure meals instead of free-feeding, and keep up daily exercise."
        ),
        Animal(
            name: "Pug",
            species: "Pug",
            category: .dog,
            imageName: "Pug",
            idealEnvironment: "Apartment-friendly, calm indoor environment with air conditioning; sensitive to heat and humidity due to its flat face.",
            bestFood: "Small-breed formulated kibble, portion-controlled meals, lean proteins.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty or fried table scraps.",
            specificTip: "Avoid strenuous exercise in heat — pugs overheat and struggle to breathe easily because of their short snouts."
        ),
        Animal(
            name: "Golden Retriever",
            species: "Golden Retriever",
            category: .dog,
            imageName: "Golden Retriever",
            idealEnvironment: "Spacious home with a yard, thrives around families and other pets, needs regular mental and physical stimulation.",
            bestFood: "High-protein diet with omega-3s (fish oil) for coat health, lean meats, vegetables.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, high-fat table scraps.",
            specificTip: "The breed has an above-average cancer risk — regular vet checkups and monitoring for new lumps matters more than usual."
        ),
        Animal(
            name: "German Shepherd",
            species: "German Shepherd Dog",
            category: .dog,
            imageName: "German Shepherd",
            idealEnvironment: "Needs space to move and strong mental stimulation — a working breed that does best with training, tasks, or a job to do.",
            bestFood: "High-protein large-breed formula with joint-supporting nutrients like glucosamine.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty foods.",
            specificTip: "Prone to hip and elbow dysplasia — avoid excessive jumping or stairs while the joints are still developing as a puppy."
        ),
        Animal(
            name: "Rottweiler",
            species: "Rottweiler",
            category: .dog,
            imageName: "Rottweiler",
            idealEnvironment: "Needs firm, consistent training and early socialization; does best with active, experienced owners.",
            bestFood: "Large-breed formulated food with controlled calcium levels while growing, to support healthy joint development.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty scraps.",
            specificTip: "Deep-chested breed — feed two smaller meals a day instead of one large one, and avoid vigorous exercise right after eating (bloat risk)."
        ),
        Animal(
            name: "Beagle",
            species: "Beagle",
            category: .dog,
            imageName: "Beagle",
            idealEnvironment: "Does well in a home with a securely fenced yard — strong nose-driven instincts mean they'll follow a scent trail if given the chance.",
            bestFood: "Portion-controlled small/medium-breed kibble; prone to overeating if allowed to free-feed.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty table scraps.",
            specificTip: "One of the most food-motivated breeds — this makes training easy but weight gain easy too, so measure every meal."
        ),
        Animal(
            name: "Poodle",
            species: "Poodle",
            category: .dog,
            imageName: "Poodle",
            idealEnvironment: "Adapts well to apartments or houses; highly intelligent and needs regular mental stimulation alongside physical exercise.",
            bestFood: "High-quality kibble with balanced protein; smaller toy/miniature poodles need portion sizes adjusted for their size.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty scraps.",
            specificTip: "Their curly coat doesn't shed much but mats easily — regular professional grooming every 4-6 weeks is close to essential."
        ),
        Animal(
            name: "Boxer",
            species: "Boxer",
            category: .dog,
            imageName: "Boxer",
            idealEnvironment: "Needs an active household with daily exercise; playful and energetic, does best with a securely fenced yard.",
            bestFood: "High-protein diet suited to a muscular build, moderate fat to maintain energy without excess weight.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty foods.",
            specificTip: "Like other short-snouted breeds, boxers are heat-sensitive — avoid exercise during the hottest parts of the day."
        ),
        Animal(
            name: "Dachshund",
            species: "Dachshund",
            category: .dog,
            imageName: "Dachshund",
            idealEnvironment: "Comfortable in apartments; needs its long back protected from strain, so limit jumping on/off furniture.",
            bestFood: "Portion-controlled small-breed kibble — this breed gains weight easily, which adds dangerous strain on its spine.",
            foodToAvoid: "Chocolate, grapes, onions, garlic, xylitol, fatty table scraps.",
            specificTip: "Highly prone to intervertebral disc disease — use ramps or steps instead of letting them jump from beds or couches."
        ),

        // MARK: Cats
        Animal(
            name: "Persian White",
            species: "Persian Cat",
            category: .cat,
            imageName: "Persian White",
            idealEnvironment: "Indoor-only, calm and quiet home, kept away from heat since their long coat traps warmth.",
            bestFood: "High-quality wet food for hydration, plus a hairball-control formula.",
            foodToAvoid: "Milk/dairy, onions, garlic, chocolate, raw dough.",
            specificTip: "Daily brushing is essential — the long coat mats quickly, and flat faces make them prone to tear staining and hairballs."
        ),
        Animal(
            name: "British Shorthair",
            species: "British Shorthair",
            category: .cat,
            imageName: "British Shorthair",
            idealEnvironment: "Calm indoor cat, low-energy, tolerates being alone better than most breeds, enjoys cozy resting spots.",
            bestFood: "Portion-controlled dry/wet food mix — calorie control matters for this breed.",
            foodToAvoid: "Milk, onions, garlic, chocolate, grapes.",
            specificTip: "Naturally low-activity — encourage regular play with toys to prevent the weight gain this breed is prone to."
        ),
        Animal(
            name: "Ragdoll",
            species: "Ragdoll Cat",
            category: .cat,
            imageName: "Ragdoll",
            idealEnvironment: "Indoor-only, calm household — known for being docile and going limp when held, hence the name.",
            bestFood: "High-protein wet/dry food mix; prone to weight gain so portion control matters.",
            foodToAvoid: "Milk, onions, garlic, chocolate, raw dough.",
            specificTip: "Very trusting and low self-defense instinct — best kept strictly indoors, away from outdoor hazards."
        ),
        Animal(
            name: "Maine Coon",
            species: "Maine Coon Cat",
            category: .cat,
            imageName: "Maine Coon",
            idealEnvironment: "Adaptable to indoor or supervised outdoor space; large breed that appreciates room to roam.",
            bestFood: "High-protein diet suited to a larger-than-average body frame; large-breed cat formula if available.",
            foodToAvoid: "Milk, onions, garlic, chocolate, raw dough.",
            specificTip: "Prone to hypertrophic cardiomyopathy (a heart condition) — regular vet checkups are especially important for this breed."
        ),
        Animal(
            name: "Siamese",
            species: "Siamese Cat",
            category: .cat,
            imageName: "Siamese",
            idealEnvironment: "Highly social and vocal — does poorly left alone for long periods; thrives with an engaged owner or a companion animal.",
            bestFood: "High-protein wet/dry mix; lean toward lower-carb formulas as the breed can be prone to diabetes.",
            foodToAvoid: "Milk, onions, garlic, chocolate, grapes.",
            specificTip: "Extremely vocal by nature — near-constant meowing is normal for this breed, not a sign something's wrong."
        ),
        Animal(
            name: "Bengal",
            species: "Bengal Cat",
            category: .cat,
            imageName: "Bengal",
            idealEnvironment: "Needs significant mental and physical stimulation — cat trees, puzzle feeders, and daily play are close to mandatory.",
            bestFood: "High-protein, low-carb diet reflecting its wild ancestry (Asian leopard cat); many owners include raw or high-meat-content food.",
            foodToAvoid: "Milk, onions, garlic, chocolate, raw dough.",
            specificTip: "One of the most energetic domestic breeds — an under-stimulated Bengal often turns destructive out of boredom."
        ),
        Animal(
            name: "Sphynx",
            species: "Sphynx Cat",
            category: .cat,
            imageName: "Sphynx",
            idealEnvironment: "Indoor-only and kept warm — being hairless, they're sensitive to both cold and direct sun exposure.",
            bestFood: "High-calorie, high-protein diet — their lack of fur means a faster metabolism to maintain body heat.",
            foodToAvoid: "Milk, onions, garlic, chocolate, raw dough.",
            specificTip: "Needs regular bathing (unusual for cats) since there's no fur to absorb their skin's natural oils."
        ),
        Animal(
            name: "Scottish Fold",
            species: "Scottish Fold",
            category: .cat,
            imageName: "Scottish Fold",
            idealEnvironment: "Calm indoor home; adaptable and affectionate, does well with families and other pets.",
            bestFood: "Balanced wet/dry food mix with joint-supporting nutrients, given the breed's predisposition to cartilage issues.",
            foodToAvoid: "Milk, onions, garlic, chocolate, raw dough.",
            specificTip: "The folded-ear gene is linked to cartilage and joint problems — watch for stiffness or reluctance to jump, and flag it to a vet early."
        ),
        Animal(
            name: "Himalayan",
            species: "Himalayan Cat",
            category: .cat,
            imageName: "Himalayan",
            idealEnvironment: "Indoor-only, calm and quiet home similar to a Persian's needs, since it's a Persian/Siamese cross.",
            bestFood: "High-quality wet food for hydration, plus hairball-control formula.",
            foodToAvoid: "Milk, onions, garlic, chocolate, raw dough.",
            specificTip: "Combines the Persian's long coat with the Siamese's colorpoint pattern — daily brushing prevents painful matting."
        ),

        // MARK: Birds
        Animal(
            name: "Pigeon",
            species: "Rock Pigeon",
            category: .bird,
            imageName: "Pigeon",
            idealEnvironment: "Open, ventilated loft or coop with room to fly; social birds best kept in pairs or groups.",
            bestFood: "Grain and seed mix (corn, wheat, peas) with added grit to aid digestion.",
            foodToAvoid: "Avocado, chocolate, salty foods, moldy grain.",
            specificTip: "Pigeons mate for life and are highly social — isolating one long-term causes real stress."
        ),
        Animal(
            name: "Parrot",
            species: "Parrot",
            category: .bird,
            imageName: "Parrot",
            idealEnvironment: "Spacious cage with room to spread its wings, plus toys or puzzles for mental stimulation and daily social interaction.",
            bestFood: "Pellet-based diet supplemented with fresh vegetables and fruits.",
            foodToAvoid: "Avocado, chocolate, caffeine, salty or sugary snacks, alcohol.",
            specificTip: "Highly intelligent and prone to anxiety or feather-plucking from boredom — rotate toys and give daily out-of-cage time."
        ),
        Animal(
            name: "Sparrow",
            species: "House Sparrow",
            category: .bird,
            imageName: "Sparrow",
            idealEnvironment: "A wild, free-flying bird best not kept caged; if rehabilitating an injured one, needs a quiet, warm, sheltered space.",
            bestFood: "Small seeds and grains, plus insects — especially important for feeding chicks.",
            foodToAvoid: "Bread (low nutritional value), salty foods, avocado.",
            specificTip: "Sparrows are becoming rare in cities — a small nest box or shallow water dish can genuinely help local populations."
        ),
        Animal(
            name: "Cockatiel",
            species: "Cockatiel",
            category: .bird,
            imageName: "Cockatiel",
            idealEnvironment: "A roomy cage with horizontal space to move, plus daily supervised time outside the cage; social and bonds closely with owners.",
            bestFood: "Pellet-based diet supplemented with seeds, fresh vegetables, and occasional fruit.",
            foodToAvoid: "Avocado, chocolate, caffeine, salty snacks, high-fat seed-only diets.",
            specificTip: "Known for whistling and mimicking sounds — a sudden drop in vocalization or activity is often an early sign something's wrong."
        ),
        Animal(
            name: "Budgerigar",
            species: "Budgerigar (Budgie)",
            category: .bird,
            imageName: "Budgerigar",
            idealEnvironment: "Does best in pairs or small groups in a cage with horizontal bars for climbing; needs daily out-of-cage flight time.",
            bestFood: "Pellet or seed mix supplemented with fresh leafy greens and vegetables.",
            foodToAvoid: "Avocado, chocolate, caffeine, salty foods, fruit seeds/pits.",
            specificTip: "One of the most food-motivated small birds — fluffed-up feathers with reduced appetite is a common early illness sign to watch for."
        ),
        Animal(
            name: "Owl",
            species: "Owl",
            category: .bird,
            imageName: "Owl",
            idealEnvironment: "A wild raptor, not a conventional pet — in most regions keeping one requires special permits; rehabilitation needs a quiet, low-stress enclosure.",
            bestFood: "Whole prey diet (mice, small rodents) reflecting its natural carnivorous behavior.",
            foodToAvoid: "Any processed or cooked food, dairy, bread.",
            specificTip: "Owls are strictly nocturnal hunters — daytime handling or exposure causes significant stress and should be minimized."
        ),
        Animal(
            name: "Peacock",
            species: "Indian Peafowl",
            category: .bird,
            imageName: "Peacock",
            idealEnvironment: "Needs a large open outdoor space with trees or high perches to roost on at night, away from ground predators.",
            bestFood: "Grain-based poultry feed supplemented with fruits, vegetables, and occasional insects.",
            foodToAvoid: "Salty or processed food, chocolate, avocado.",
            specificTip: "Males shed and regrow their iconic tail feathers annually — this is completely natural and not a sign of illness."
        ),
        Animal(
            name: "Crow",
            species: "House Crow",
            category: .bird,
            imageName: "Crow",
            idealEnvironment: "A wild bird, highly intelligent and social — not suited to caging; rehabilitation needs space to exercise problem-solving behavior.",
            bestFood: "Omnivorous diet — grains, fruits, insects, and small amounts of meat scraps.",
            foodToAvoid: "Chocolate, avocado, salty processed food.",
            specificTip: "Among the most intelligent birds studied — known to use tools and recognize individual human faces over years."
        ),
        Animal(
            name: "Duck",
            species: "Domestic Duck",
            category: .bird,
            imageName: "Duck",
            idealEnvironment: "Access to a water source for swimming and preening, plus a dry, predator-secure shelter at night.",
            bestFood: "Waterfowl-specific feed or poultry grain mix, supplemented with leafy greens and aquatic plants.",
            foodToAvoid: "Bread (causes malnutrition if overfed), chocolate, avocado, salty food.",
            specificTip: "Ducks need constant access to water not just for drinking but to keep their eyes and nostrils clean and healthy."
        ),

        // MARK: Farm Animals
        Animal(
            name: "Cow",
            species: "Domestic Cattle",
            category: .farmAnimal,
            imageName: "Cow",
            idealEnvironment: "Open pasture with grazing space, shelter from extreme heat or cold, and constant access to clean water.",
            bestFood: "Grass, hay, and silage, with a balanced grain supplement for dairy cows.",
            foodToAvoid: "Moldy or spoiled feed, chocolate, avocado, large amounts of grain (bloat/acidosis risk).",
            specificTip: "Cows are herd animals and get visibly stressed when isolated — keeping at least one companion animal nearby helps their wellbeing."
        ),
        Animal(
            name: "Buffalo",
            species: "Water Buffalo",
            category: .farmAnimal,
            imageName: "Buffalo",
            idealEnvironment: "Access to water for wallowing to regulate body temperature, open grazing land, and shade.",
            bestFood: "Grass, hay, and fodder crops, with supplemental grain during milk production.",
            foodToAvoid: "Moldy feed, excessive grain, chocolate.",
            specificTip: "Buffaloes handle heat poorly without water access — regular wallowing or bathing prevents heat stress, especially in summer."
        ),
        Animal(
            name: "Horse",
            species: "Domestic Horse",
            category: .farmAnimal,
            imageName: "Horse",
            idealEnvironment: "Open pasture with room to move, shelter from weather, and herd companionship — horses are social animals.",
            bestFood: "Grass or hay as the base diet, with grain supplements in moderation for working horses.",
            foodToAvoid: "Chocolate, avocado, excess sugary treats, moldy hay (colic risk).",
            specificTip: "Horses can't vomit — overeating grain or spoiled feed can quickly turn into a life-threatening colic, so feed is always carefully measured."
        ),
        Animal(
            name: "Goat",
            species: "Domestic Goat",
            category: .farmAnimal,
            imageName: "Goat",
            idealEnvironment: "Fenced pasture or yard with room to climb and explore — goats are curious and notorious escape artists if not securely fenced.",
            bestFood: "Hay and pasture grazing as the base, supplemented with grain for dairy or growing goats.",
            foodToAvoid: "Chocolate, avocado, moldy feed, excessive grain (bloat risk), azaleas and other toxic plants.",
            specificTip: "Goats are herd animals — keeping a goat alone without at least one companion goat causes significant stress over time."
        ),
        Animal(
            name: "Sheep",
            species: "Domestic Sheep",
            category: .farmAnimal,
            imageName: "Sheep",
            idealEnvironment: "Open pasture with shelter from rain and extreme heat; flock animals that do best in groups of at least a few.",
            bestFood: "Grass and hay as the primary diet, with mineral supplements — sheep have specific copper sensitivity to watch for.",
            foodToAvoid: "Copper-rich feeds meant for other livestock (toxic to sheep), chocolate, avocado, moldy feed.",
            specificTip: "Sheep are highly copper-sensitive — never feed them cattle or goat mineral mixes, which often contain copper levels that are toxic to sheep."
        ),
        Animal(
            name: "Pig",
            species: "Domestic Pig",
            category: .farmAnimal,
            imageName: "Pig",
            idealEnvironment: "Needs mud or water access to cool off (pigs can't sweat effectively), shelter, and rooting space to express natural digging behavior.",
            bestFood: "Balanced grain-based feed with protein supplements, plus vegetables and fruit scraps in moderation.",
            foodToAvoid: "Chocolate, avocado, salty processed food, raw meat.",
            specificTip: "Pigs are among the most intelligent farm animals — they benefit noticeably from environmental enrichment like rooting toys or puzzle feeders."
        ),
        Animal(
            name: "Donkey",
            species: "Domestic Donkey",
            category: .farmAnimal,
            imageName: "Donkey",
            idealEnvironment: "Dry, well-drained pasture with shelter — donkeys are more sensitive to wet conditions than horses and prone to hoof problems if kept damp.",
            bestFood: "Low-sugar hay or straw-based diet — donkeys need far less rich feed than horses and are prone to obesity on horse-level rations.",
            foodToAvoid: "Rich grain feed meant for horses, chocolate, avocado, moldy hay.",
            specificTip: "Donkeys evolved for arid, sparse terrain — overfeeding on lush pasture or horse feed is one of the most common health issues owners cause unintentionally."
        ),

        // MARK: Rodents
        Animal(
            name: "Hamster",
            species: "Syrian Hamster",
            category: .rodent,
            imageName: "Hamster",
            idealEnvironment: "Solitary housing (most species fight if paired), a spacious cage with bedding for burrowing, away from drafts.",
            bestFood: "Commercial hamster seed/pellet mix with occasional fresh vegetables.",
            foodToAvoid: "Citrus fruits, onion, garlic, chocolate, bitter almonds.",
            specificTip: "Nocturnal by nature — expect activity at night, and avoid disturbing daytime sleep, which stresses them out."
        ),
        Animal(
            name: "Rabbit",
            species: "Domestic Rabbit",
            category: .rodent,
            imageName: "Rabbit",
            idealEnvironment: "Spacious enclosure or a bunny-proofed room with daily hopping/exercise space, kept away from extreme heat.",
            bestFood: "Unlimited timothy hay as the base, plus leafy greens and a small portion of pellets.",
            foodToAvoid: "Iceberg lettuce, sugary treats, avocado, chocolate.",
            specificTip: "A rabbit's teeth grow continuously — constant access to hay wears them down naturally and prevents painful overgrowth."
        ),
        Animal(
            name: "Guinea Pig",
            species: "Guinea Pig",
            category: .rodent,
            imageName: "Guinea Pig",
            idealEnvironment: "Spacious cage kept in pairs or groups (highly social), away from drafts and extreme temperature swings.",
            bestFood: "Unlimited timothy hay, fresh vegetables high in vitamin C, and guinea-pig-specific pellets.",
            foodToAvoid: "Iceberg lettuce, sugary fruit in excess, chocolate, dairy.",
            specificTip: "Unlike most rodents, guinea pigs can't produce their own vitamin C — their diet must include a reliable source or they risk scurvy."
        ),
        Animal(
            name: "Mouse",
            species: "Fancy Mouse",
            category: .rodent,
            imageName: "Mouse",
            idealEnvironment: "Secure, escape-proof cage with fine bar spacing, bedding for burrowing, kept in same-sex groups to prevent unwanted breeding.",
            bestFood: "Commercial mouse pellet mix supplemented with small amounts of fresh vegetables and seeds.",
            foodToAvoid: "Chocolate, citrus, onion, garlic, sugary treats.",
            specificTip: "Mice breed extremely fast — keep males and females separated unless breeding is intentional, since litters can arrive within weeks."
        ),
        Animal(
            name: "Rat",
            species: "Fancy Rat",
            category: .rodent,
            imageName: "Rat",
            idealEnvironment: "Multi-level cage with climbing space, kept in pairs or groups — rats are highly social and do poorly alone long-term.",
            bestFood: "Lab-block/pellet-based diet supplemented with fresh vegetables and occasional protein like cooked egg.",
            foodToAvoid: "Citrus (in excess), chocolate, carbonated drinks, raw sweet potato.",
            specificTip: "Despite their reputation, rats are among the most trainable and socially affectionate small pets — daily interaction genuinely matters to them."
        ),
        Animal(
            name: "Chinchilla",
            species: "Chinchilla",
            category: .rodent,
            imageName: "Chinchilla",
            idealEnvironment: "Cool environment (below 75°F/24°C) — their dense fur makes them prone to heatstroke; needs a dust bath regularly instead of water bathing.",
            bestFood: "Chinchilla-specific hay-based pellets and unlimited timothy hay; very sensitive digestive system.",
            foodToAvoid: "Sugary fruits, nuts, seeds in excess, fresh greens (can cause bloating), any water-based bathing.",
            specificTip: "Never let a chinchilla get wet — their extremely dense fur traps moisture against the skin and can lead to fungal infections; dust baths only."
        ),
        Animal(
            name: "Gerbil",
            species: "Mongolian Gerbil",
            category: .rodent,
            imageName: "Gerbil",
            idealEnvironment: "Deep-bedded enclosure for tunneling, kept in same-sex pairs or small groups — highly social and active during the day and night.",
            bestFood: "Commercial gerbil seed/pellet mix with occasional fresh vegetables.",
            foodToAvoid: "Citrus fruits, onion, garlic, chocolate, sugary treats.",
            specificTip: "Gerbils are desert animals and need very little water — overly damp bedding or excess fresh produce can cause digestive upset."
        ),
        Animal(
            name: "Squirrel",
            species: "Squirrel",
            category: .rodent,
            imageName: "Squirrel",
            idealEnvironment: "In most regions a wild animal, not legal to keep as a pet — if rehabilitating, needs a spacious enclosure with climbing branches.",
            bestFood: "Nuts, seeds, and fresh fruit/vegetables — in the wild, a varied foraged diet.",
            foodToAvoid: "Chocolate, avocado, processed/salty human food, dairy.",
            specificTip: "Squirrels cache food for winter as instinct — providing scattered foraging opportunities (not just a bowl) supports natural behavior in rehab settings."
        ),

        // MARK: Reptiles
        Animal(
            name: "Turtle",
            species: "Turtle",
            category: .reptile,
            imageName: "Turtle",
            idealEnvironment: "Depends on the species — aquatic turtles need a water tank with a basking area and UVB light; land species need a dry enclosure with hiding spots.",
            bestFood: "Varies by species — typically a mix of leafy greens, commercial turtle pellets, and occasional protein like worms for omnivorous types.",
            foodToAvoid: "Dairy products, processed or salty human food, iceberg lettuce (low nutrition).",
            specificTip: "UVB lighting isn't optional — without it, turtles can't metabolize calcium properly and develop serious shell and bone problems."
        ),
        Animal(
            name: "Tortoise",
            species: "Tortoise",
            category: .reptile,
            imageName: "Tortoise",
            idealEnvironment: "Dry land enclosure or outdoor pen with a basking spot, UVB lighting, and a shallow water dish — never a water tank like aquatic turtles.",
            bestFood: "High-fiber leafy greens and weeds as the base diet; low protein, low sugar compared to a turtle's diet.",
            foodToAvoid: "Fruit in excess (too sugary for most species), dairy, iceberg lettuce, processed food.",
            specificTip: "Overfeeding fruit is one of the most common tortoise-keeping mistakes — most species need a diet that's almost entirely leafy greens and weeds."
        ),
        Animal(
            name: "Gecko",
            species: "Leopard Gecko",
            category: .reptile,
            imageName: "Gecko",
            idealEnvironment: "A warm, dry terrarium with a temperature gradient (a cool side and a warm basking side) and hiding spots on both ends.",
            bestFood: "Live insects — crickets, mealworms, dubia roaches — dusted with calcium powder.",
            foodToAvoid: "Wild-caught insects (pesticide/parasite risk), fruits or vegetables (geckos are insectivores, not omnivores).",
            specificTip: "Unlike many reptiles, leopard geckos don't strictly need UVB lighting, but a proper heat gradient is non-negotiable for digestion."
        ),
        Animal(
            name: "Iguana",
            species: "Green Iguana",
            category: .reptile,
            imageName: "Iguana",
            idealEnvironment: "A large, tall enclosure with strong branches for climbing, high humidity, and intense UVB lighting — grows much larger than most owners expect.",
            bestFood: "Almost entirely leafy greens and vegetables — iguanas are herbivores, unlike most other pet lizards.",
            foodToAvoid: "Any animal protein (can cause kidney damage over time), iceberg lettuce, dairy, avocado.",
            specificTip: "Iguanas can grow over 5 feet long — this is one of the most under-researched pet purchases, so enclosure size needs planning years in advance."
        ),
        Animal(
            name: "Corn Snake",
            species: "Corn Snake",
            category: .reptile,
            imageName: "Corn Snake",
            idealEnvironment: "A secure, escape-proof enclosure with a temperature gradient and hiding spots on both the warm and cool ends.",
            bestFood: "Appropriately sized frozen-thawed mice, fed roughly every 1-2 weeks depending on age.",
            foodToAvoid: "Live prey (injury risk to the snake), any non-rodent food.",
            specificTip: "Handle a corn snake only when it's not in a shedding cycle (cloudy eyes) — their vision is impaired then and handling adds unnecessary stress."
        ),
        Animal(
            name: "Bearded Dragon",
            species: "Bearded Dragon",
            category: .reptile,
            imageName: "Bearded Dragon",
            idealEnvironment: "A large, warm terrarium with a strong basking spot, UVB lighting, and enough floor space to move between temperature zones.",
            bestFood: "Omnivorous — a mix of leafy greens/vegetables and gut-loaded insects, with the ratio shifting toward more greens as they mature.",
            foodToAvoid: "Avocado, rhubarb, fireflies (toxic to this species specifically), high-oxalate vegetables like spinach in excess.",
            specificTip: "Diet needs change significantly with age — juveniles need mostly insects for protein, while adults need mostly vegetables."
        ),
        Animal(
            name: "Chameleon",
            species: "Veiled Chameleon",
            category: .reptile,
            imageName: "Chameleon",
            idealEnvironment: "A tall, well-ventilated mesh enclosure with live plants, misting for humidity, and strong UVB lighting — solitary, stressed by handling or other chameleons in sight.",
            bestFood: "Live gut-loaded insects (crickets, roaches) dusted with calcium and vitamin supplements.",
            foodToAvoid: "Wild-caught insects, any fruits/vegetables in significant quantity (chameleons are primarily insectivorous).",
            specificTip: "Chameleons drink only moving water droplets, not from a still bowl — a dripper or misting system is essential, not optional."
        ),
        Animal(
            name: "Monitor Lizard",
            species: "Monitor Lizard",
            category: .reptile,
            imageName: "Monitor Lizard",
            idealEnvironment: "A very large, secure enclosure (species-dependent, often room-sized for adults) with strong heating, UVB, and enrichment for their high intelligence.",
            bestFood: "Whole prey diet — appropriately sized rodents, with some species also eating insects and eggs.",
            foodToAvoid: "Processed meat, dairy, food not appropriately sized (choking/impaction risk).",
            specificTip: "Among the most intelligent reptiles kept as pets — under-stimulated monitors can become stressed or defensive, so enclosure enrichment matters more than for most reptiles."
        )
    ]
}
