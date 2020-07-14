using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Billboarder : MonoBehaviour
{
    public bool facingPlayer = false;

    SpriteRenderer sr;

    public Transform cam;

    public Vector3 dirToPlayer, walkingDir;

    public float angleToPlayer;
    public float walkingDirAngle;
    public float angleComparison;

    float dist1, dist2;
    Vector3 s1, s2;
    public Transform player;

    // Start is called before the first frame update
    void Start()
    {
        player = MoveController.instance.transform;
        sr = GetComponent<SpriteRenderer>();
        cam = Camera.main.transform;
    }

    // Update is called once per frame
    void Update()
    {
        transform.LookAt(cam);  // MoveController.instance.transform);
        dist2 = dist1;
        dist1 = Vector3.Distance(transform.position, MoveController.instance.transform.position);

        dirToPlayer = (player.position - transform.position).normalized;

        angleToPlayer = Mathf.Atan2(dirToPlayer.z, dirToPlayer.x) * Mathf.Rad2Deg;

        s1 = s2;
        s2 = transform.position;
        walkingDir = (s2 - s1).normalized;
        walkingDirAngle = Mathf.Atan2(walkingDir.z, walkingDir.x) * Mathf.Rad2Deg;

        angleComparison = Mathf.Abs(angleToPlayer - walkingDirAngle);

        if (angleComparison >= 0 && angleComparison < 90)
        {
            facingPlayer = true;
            sr.flipX = !true;
        }
        if (angleComparison <= 360 && angleComparison > 270)
        {
            facingPlayer = true;
            sr.flipX = !false;
        }
        if (angleComparison >= 180 && angleComparison < 270)
        {
            facingPlayer = false;
            sr.flipX = !true;
        }
        if (angleComparison < 180 && angleComparison > 90)
        {
            facingPlayer = false;
            sr.flipX = !false;
        }

        //facingPlayer = dist1 <= dist2;
    }   
}
