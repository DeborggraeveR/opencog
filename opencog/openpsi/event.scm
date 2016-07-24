; --------------------------------------------------------------
; Event Detection
;
; Event detection works by monitoring the timestamp of the event's most recent
; occurrence, which is stored via StateLink. Eventually, this should be evaluated
; through use of the time server. An historical "previous" most recent event ts
; is also stored, so we can know when a new event has occurred when the "current"
; most recent ts differs from the "previous" most recent ts. In essence, the
; "value" of the event being monitored for change is the ts of its most recent
; occurrence. The current apporach relies on something outside of OpenPsi to set
; the most-recent-event-ts each time the event occurs. One place where this
; can happen is through an event-detection callback (see psi-set-event-callback),
; which is called at each step of the psi-dynamics loop.

(define psi-event-node (Concept (string-append psi-prefix-str "event")))

(define-public (psi-create-monitored-event event)
	(define event-concept (Concept (string-append psi-prefix-str event)))
	(Inheritance event-concept psi-event-node)
	; Initialize value to 0, when an instance of the event occurs, value will be
	; set to 1.
	(psi-set-value! event-concept 0)
	;(format #t "new event: ~a\n" event-concept)
	event-concept)

(define-public (psi-get-monitored-events)
"
  Returns a list containing all the monitored events.
"
    (filter
        (lambda (x) (not (equal? x psi-event-node)))
        (cog-chase-link 'InheritanceLink 'ConceptNode psi-event-node))
)



(define-public psi-most-recent-occurrence-pred
    (Predicate "psi-most-recent-occurrence"))

(define-public (psi-set-event-occurrence! event)
    (State
        (List
            event
            psi-most-recent-occurrence-pred)
        (TimeNode (number->string (current-time)))))

