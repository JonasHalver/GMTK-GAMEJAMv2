using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class ZombieAI : MonoBehaviour
{
    NavMeshAgent agent;
    NavMeshPath currentPath;

    public Life life;

    public bool facingPlayer = false;

    public enum State { Idle, Approaching, Aggressive, Searching, Dead }
    public State currentState = State.Idle;

    Billboarder billboarder;
    public float viewDistance = 7.5f;
    public LayerMask playerMask, obstacleMask;

    Vector3 searchLocation;

    // Start is called before the first frame update
    void Start()
    {
        billboarder = transform.GetChild(0).GetComponent<Billboarder>();
        life = GetComponent<Life>();
        agent = GetComponent<NavMeshAgent>();
        agent.autoBraking = true;
        currentPath = new NavMeshPath();
    }

    // Update is called once per frame
    void Update()
    {
        StateMachine();
        if (life.isDead)
            currentState = State.Dead;
    }

    void StateMachine()
    {
        switch (currentState)
        {
            case State.Idle:
                agent.speed = 2;
                IdleMovement();

                if (life.hitPointsCurrent < life.hitPointsMax)
                    currentState = State.Aggressive;

                if (PlayerSpotted())
                    currentState = State.Approaching;
                break;
            case State.Approaching:
                agent.speed = 2.5f;

                if (life.hitPointsCurrent < life.hitPointsMax)
                    currentState = State.Aggressive;

                if (!PlayerSpotted())
                    currentState = State.Idle;

                break;
            case State.Aggressive:
                agent.speed = 3.5f;
                agent.destination = MoveController.instance.transform.position;
                break;
            case State.Searching:
                agent.destination = searchLocation;

                if (agent.remainingDistance < 0.5f)
                    currentState = State.Idle;

                if (life.hitPointsCurrent < life.hitPointsMax)
                    currentState = State.Aggressive;

                if (PlayerSpotted())
                    currentState = State.Approaching;
                break;
            case State.Dead:
                agent.isStopped = true;
                this.enabled = false;
                break;

        }
    }

    public void IdleMovement()
    {
        if (!agent.hasPath)
        {
            agent.CalculatePath(Random.insideUnitSphere * 10 + transform.position, currentPath);
            if (currentPath.status == NavMeshPathStatus.PathComplete)
            {
                agent.SetPath(currentPath);
            }
            else
            {
                //currentPath = null;
            }
        }
        else
        {
            if (agent.remainingDistance < 0.5f)
            {
                agent.ResetPath();
                //currentPath = new NavMeshPath();
            }
        }
    }

    public bool PlayerSpotted()
    {
        bool output = false;

        Vector3 dirtoPlayer = MoveController.instance.transform.position - transform.position.normalized;
        if (!Physics.Raycast(transform.position, dirtoPlayer, viewDistance, obstacleMask))
        {
            if (Physics.Raycast(transform.position, dirtoPlayer, viewDistance, playerMask))
            {
                output = true;
            }
        }

        if (!billboarder.facingPlayer)
        {
            output = false;
        }

        return output;
    }

    public void SoundHeard(Vector3 location)
    {
        searchLocation = location;
        if (currentState != State.Aggressive && !PlayerSpotted())
        {
            currentState = State.Searching;
        }
        else
        {
            currentState = State.Aggressive;
        }
    }
}
